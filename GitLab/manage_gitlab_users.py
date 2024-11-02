#!/usr/bin/env python3
# --------------------------------------------------------------------------- #
# Manage GitLab Users (List/Block inactive users)
# --------------------------------------------------------------------------- #
# See
#  - 'Groups API'     https://docs.gitlab.com/ee/api/groups.html
#  - 'Projects API'   https://docs.gitlab.com/ee/api/projects.html
#  - 'Users API'      https://docs.gitlab.com/ee/api/users.html#for-administrators
# --------------------------------------------------------------------------- #

from types import SimpleNamespace           # Used for 'struct' objects
from datetime import datetime, timedelta    # Date/Time handling
import argparse                 # Parse command-line arguments
import csv                      # Read/Write CSV files
import json                     # Pretty-print JSON-like structures
import pandas                   # Python table
import requests                 # Perform HTTP requests
from tabulate import tabulate   # Pretty-print table
# import urllib.parse             # URL Encode a string

# Import SE-DevOps Utilities
import site
import sys
site.addsitedir("..")
site.addsitedir("../Python")
import devops_fun as do_fun
from devops_gitlab_api import (
    do_gitlab_api_block_user,
    do_gitlab_api_get_total_pages,
    do_gitlab_api_is_admin_token
)

# Constants ----------------------------------------------------------------- #

# Grace Period for Orphan Users (in days), before blocking them
ORPHAN_USERS_GRACE_PERIOD_DAYS = 7

# Sort-order for users-list
REPORT_SORT_LIST    = [ 'last_activity_on' ]
REPORT_COLUMNS      = [ 'id', 'username', 'name', 'state', 'using_license_seat', 'is_admin', 'is_auditor', 'last_activity_on', 'created_at' ]

ACTION_LIST_ONLY        = 'list'
ACTION_BLOCK_INACTIVE   = 'block_inactive'
ACTION_BLOCK_ORPHAN     = 'block_orphan'
VALID_ACTIONS_LIST      = [ ACTION_LIST_ONLY, ACTION_BLOCK_INACTIVE, ACTION_BLOCK_ORPHAN ]

# User API-Call Settings
USER_API_ALL        = ''
USER_API_ORPHAN     = 'without_projects=true'

# User States
USER_STATE_ACTIVE   = 'active'
USER_STATE_INACTIVE = 'deactivated'
USER_STATE_BLOCKED  = 'blocked'
USER_STATE_BLCK_LDP = 'ldap_blocked'

# API-Call Settings
PER_PAGE = 100

# Global Variables ---------------------------------------------------------- #

_args = argparse.Namespace()
_my   = SimpleNamespace()

# Functions ----------------------------------------------------------------- #

def block_user( user_to_block ):

    user_id             = user_to_block['id']
    formatted_username  = "'%s'" % ( user_to_block['username'] )
    formatted_name      = "(%s)" % ( user_to_block['name'] )

    do_fun.trace_inf( "Blocking User %4d %-20s %-27s" % ( user_id, formatted_username, formatted_name ) )

    if ( _args.is_dry_run ):
        do_fun.trace_wrn( "DRY-RUN: Skip %4d %-20s %-27s" % ( user_id, formatted_username, formatted_name ) )
        return()
    else:
        do_gitlab_api_block_user( user_id, _args.token, _my.server_url, True )

    return()


def block_users_in_list( list_type, users_to_block_list ):

    num_users_to_block = len( users_to_block_list )

    do_fun.trace_inf( "Blocking %d %s users..." % ( num_users_to_block, list_type ) )

    if ( not users_to_block_list ):
        do_fun.trace_inf( "Nothing to do - no %s users to block" % ( list_type ) )
        return()

    for user_to_block in users_to_block_list:
        block_user( user_to_block )

    do_fun.trace_inf( "Blocking %d %s users - Done" % ( num_users_to_block, list_type ) )

    return()


def filter_out_special_users( users_dict_list ):

    do_fun.trace_inf( "Filtering-out special users..." )

    filtered_users_list = []

    grace_period_date = datetime.today() - timedelta( days = ORPHAN_USERS_GRACE_PERIOD_DAYS )
    grace_period_date_str = grace_period_date.strftime('%Y-%m-%d')
    do_fun.trace_inf( "Orphan Users Grace Period: Last activity after '%s' (%d days)" %
                     ( grace_period_date_str, ORPHAN_USERS_GRACE_PERIOD_DAYS ) )

    for user_dict in users_dict_list:
        formatted_username = "'%s'" % ( user_dict['username'] )
        formatted_name     = "(%s)" % ( user_dict['name'] )

        if ( user_dict['state'] in [ USER_STATE_BLOCKED, USER_STATE_BLCK_LDP ] ):
            do_fun.trace_dbg( "SKIPPING User %-20s %-27s - is '%s'" %
                             ( formatted_username, formatted_name, user_dict['state'] ) )
            continue
        if ( user_dict['is_admin'] or user_dict['is_auditor'] ):
            do_fun.trace_dbg( "SKIPPING User %-20s %-27s - is Admin or Auditor" %
                             ( formatted_username, formatted_name ) )
            continue
        if ( not user_dict['using_license_seat'] ):
            do_fun.trace_dbg( "SKIPPING User %-20s %-27s - is NOT using a license-seat" %
                             ( formatted_username, formatted_name ) )
            continue
        if ( user_dict['last_activity_on'] > grace_period_date_str ):
            do_fun.trace_dbg( "SKIPPING User %-20s %-27s - last activity '%s' is after '%s'" %
                             ( formatted_username, formatted_name, user_dict['last_activity_on'], grace_period_date_str ) )
            continue

        filtered_users_list.append( user_dict )

    do_fun.trace_dbg( "Got %d \"real\" users" % ( len( filtered_users_list ) ) )

    return( filtered_users_list )


def filter_users_by_state( user_state, users_dict_list ):

    do_fun.trace_inf( "Filtering only '%s' users..." % ( user_state ) )

    filtered_users_list = []

    for user_dict in users_dict_list:
        if ( user_dict['state'] == user_state ):
            filtered_users_list.append( user_dict )

    do_fun.trace_dbg( "Got %d '%s' users" % ( len( filtered_users_list ), user_state ) )

    return( filtered_users_list )


def get_sort_order_list( order_by_str, columns_list ):

    if ( not order_by_str ):
        return REPORT_SORT_LIST

    order_by_list = order_by_str.split(',')
    do_fun.trace_dbg( "order_by_str:           ", order_by_str )
    do_fun.trace_dbg( "order_by_list:          ", order_by_list )

    confirmed_order_by_list = []
    for order_by_column in order_by_list:
        if ( order_by_column in columns_list ):
            confirmed_order_by_list.append( order_by_column )

    do_fun.trace_dbg( "confirmed_order_by_list:", confirmed_order_by_list )
    if ( not confirmed_order_by_list ):
        return REPORT_SORT_LIST
    else:
        return confirmed_order_by_list


def get_users_list( list_type, users_api_filter = '' ):

    do_fun.trace_inf( "Getting %s users..." % ( list_type ) )
    if ( users_api_filter ):
        #FIXME: May wish to confirm that the filter is valid (compared to a predefined list of valid filters)
        api_request_users_url = "%s/api/v4/users?%s&per_page=%s" % ( _my.server_url, users_api_filter, PER_PAGE )
    else:
        api_request_users_url = "%s/api/v4/users?per_page=%s" % ( _my.server_url, PER_PAGE )
    do_fun.trace_dbg( "api_request_users_url:", api_request_users_url )

    users_total_pages = do_gitlab_api_get_total_pages( api_request_users_url, _args.token, True )

    users_info_list = []

    for page in range(1, users_total_pages + 1):

        api_request_users_url_with_page = "%s&page=%s" % ( api_request_users_url, page )
        do_fun.trace_dbg( "api_request_users_url_with_page: ", api_request_users_url_with_page )

        users_list_info = requests.get( api_request_users_url_with_page,
                                        headers = { 'PRIVATE-TOKEN': _args.token },
                                        )
        if ( users_list_info.status_code == requests.codes.ok ):
            do_fun.trace_dbg( "Reading %s users (page %2d of %d) ..." % ( list_type, page, users_total_pages ) )
            users_info_list.extend( users_list_info.json() )
        else:
            do_fun.trace_err( 'Failed to get %s users on: %s (Error: %s): ' %
                             ( list_type, api_request_users_url_with_page, users_list_info.status_code ) )
            do_fun.trace_err( "users_info_list:\n%s" % ( json.dumps( users_info_list, indent=4 ) ) )
            sys.exit(1)

    if ( users_info_list ):
        do_fun.trace_inf( "Got %d %s users" % ( len( users_info_list ), list_type ) )
    else:
        if ( users_api_filter == USER_API_ALL ):
            do_fun.trace_err( "Didn't get any users - please check" )
            sys.exit(1)
        else:
            do_fun.trace_wrn( "Didn't get any %s users - please check" % ( list_type ) )

    do_fun.trace_nrm()

    if ( _args.is_verbose ):
        do_fun.trace_dbg( "List the first items we got" )

        for counter in range( 0, 2 ):
            do_fun.trace_dbg()
            do_fun.trace_dbg( "users_info_list[%d] __________________________________________________\n%s" %
                                ( counter, json.dumps( users_info_list[ counter ], indent=4 ) ) )
            do_fun.trace_dbg( "______________________________________________________________________" )
            do_fun.trace_dbg()

    return( users_info_list )


def init():

    init_arg_parse()
    init_set_trace_level()
    do_fun.trace_inf( "Init..." )
    init_set_default_values()
    init_validate_input()
    init_list_args()


def init_arg_parse():

    global _args
    parser = argparse.ArgumentParser(description="Migrate a GitLab Repository from one server to another")
    parser.add_argument("-s", "--server",       help="GitLab hostname (NOT URL)")
    parser.add_argument("-k", "--token",        help="API-Token",
                                                dest="token")
    parser.add_argument("-a", "--action",       help="Action",
                                                choices=VALID_ACTIONS_LIST)
    parser.add_argument("-n", "--dry-run",      help="Dry-Run mode - don't write anything",
                                                dest="is_dry_run",
                                                action="store_true")
    parser.add_argument("-b", "--order_by",     help="Order-by (column-header names, comma-separated)")
    parser.add_argument("-o", "--outfile",      help="Output file (default: stdout)")
    parser.add_argument("-c", "--csv",          help="Output as CSV",
                                                dest="is_csv",
                                                action="store_true")
    parser.add_argument("-q", "--quiet",        help="Quiet mode",
                                                dest="is_quiet",
                                                action="store_true")
    parser.add_argument("-v", "--verbose",      help="Verbose mode",
                                                dest="is_verbose",
                                                action="store_true")
    _args = parser.parse_args()


def init_list_args():

    do_fun.trace_dbg()
    do_fun.trace_dbg( "_args.server:        ", _args.server )
    do_fun.trace_dbg( "_args.token:         ", _args.token )
    do_fun.trace_dbg( "_args.action:        ", _args.action )
    do_fun.trace_dbg( "_args.order_by:      ", _args.order_by )
    do_fun.trace_dbg( "_args.outfile:       ", _args.outfile )
    do_fun.trace_dbg( "_args.is_csv:        ", _args.is_csv )
    do_fun.trace_dbg( "_args.is_dry_run:    ", _args.is_dry_run )
    do_fun.trace_dbg( "_args.is_quiet:      ", _args.is_quiet )
    do_fun.trace_dbg( "_args.is_verbose:    ", _args.is_verbose )
    do_fun.trace_dbg()


def init_set_default_values():

    do_fun.trace_dbg( "Setting Default Values..." )

#   _args.server = _args.server if (_args.server is not None) else "https://gitlab.perfect.com"

#   _my.source_path = re.sub( r'\s*http.*://', '', _args.address )

    _my.today_date = datetime.today().strftime('%Y-%m-%d')


def init_set_trace_level():

    if ( _args.is_verbose ):
        do_fun.trace_set_level(2)
    elif ( _args.is_quiet ):
        do_fun.trace_set_level(0)
    else:
        do_fun.trace_set_level(1)


def init_validate_input():

    do_fun.trace_dbg( "Validating Input..." )

    if ( not (_args.server) ):
        do_fun.trace_err( "Please provide gitlab-server name" )
        sys.exit(1)
    else:
        _my.server_url = "https://%s.perfect.com" % ( _args.server )

    if ( not (_args.token) ):
        do_fun.trace_err( "Please provide token" )
        sys.exit(1)

    if ( (_args.action) and (_args.action not in VALID_ACTIONS_LIST) ):
        do_fun.trace_err( "Please provide a valid action, like: %s" % ( VALID_ACTIONS_LIST ) )
        sys.exit(1)


def list_users( users_list_type, users_info_list ):

    do_fun.trace_nrm()
    do_fun.trace_nrm( "List of %s Users (%d in total)_________________________"
                        % ( users_list_type, len(users_info_list) ) )

    if ( not users_info_list ):
        do_fun.trace_nrm( " --- No %s users to list ---" % ( users_list_type ) )
        do_fun.trace_nrm()
        return()

    pandas.set_option('display.max_columns', 40)
    pandas.set_option('display.expand_frame_repr', False)
    users_df = pandas.DataFrame.from_dict( users_info_list )
    users_df = users_df[ REPORT_COLUMNS ]
#   users_df = users_df.drop(['name'], axis=1)
    do_fun.trace_dbg( "users_df.columns:\n%s" % ( users_df.columns ) )
    sort_column_headers_list = get_sort_order_list( _args.order_by, users_df.columns )
    do_fun.trace_dbg( "sort_column_headers_list:", sort_column_headers_list )

    users_df = users_df.sort_values( sort_column_headers_list )

    do_fun.trace_nrm( "Sort Order:", sort_column_headers_list )

    if ( _args.is_csv ):
        report_as_text = users_df.to_csv( index=_args.is_verbose,
                                    header=users_df.columns,
                                    quoting=csv.QUOTE_NONNUMERIC )
    else:
        report_as_text = tabulate( users_df,
                                   showindex=_args.is_verbose,
                                   headers=users_df.columns )

    do_fun.trace_nrm( "\n" + report_as_text )
    do_fun.trace_nrm( "_________________________________________________________________________" )
    do_fun.trace_nrm()

    return()


def list_user_states( list_type , users_dict_list ):

    states_dict = {}

    for user_dict in users_dict_list:
        do_fun.trace_dbg( "User %-20s %-27s is '%s'" % ( "'%s'" % (user_dict['username']), "(%s)" % (user_dict['name']), user_dict['state'] ) )
        if ( user_dict['state'] in states_dict ):
            states_dict[ user_dict['state'] ] += 1
        else:
            states_dict[ user_dict['state'] ] = 1

    do_fun.trace_inf( "%s User States (%d users)________________________________________________________" % ( list_type, len(users_dict_list) ) )

    for user_state in dict( sorted( states_dict.items() ) ):
        do_fun.trace_inf( "Got %4d %-14s users" % ( states_dict[user_state], "'" + user_state + "'") )

    do_fun.trace_nrm()


def manage_users():

    do_gitlab_api_is_admin_token( _args.token, _my.server_url, True )

    do_fun.trace_nrm()

    #FIXME: Get list of "inactive" users that are NOT 'blocked' -
    #       This is not supported by the API at the moment (v16.8),
    #       so we'll have to do it manually (see below).
    #       See https://docs.gitlab.com/ee/api/users.html where it says:
    #       "In addition, you can filter users based on the states 'blocked' and 'active'.
    #        It does not support 'active=false' or 'blocked=false'."

    all_users_list     = get_users_list( '(all)', USER_API_ALL )

    orphan_users_list  = get_users_list( 'orphan', USER_API_ORPHAN )

    list_user_states( 'All', all_users_list )

    list_user_states( 'Orphan', orphan_users_list )

    inactive_users_list = filter_users_by_state( USER_STATE_INACTIVE, all_users_list )

    real_orphan_users_list = filter_out_special_users( orphan_users_list )

    list_users( "Inactive (state '%s')" % ( USER_STATE_INACTIVE ), inactive_users_list )

    list_users( 'Orphan (without projects)', real_orphan_users_list )

    if ( _args.action ):
        if ( _args.action == ACTION_LIST_ONLY ):
            do_fun.trace_dbg( "Nothing to do - already listed the users" )
        elif ( _args.action == ACTION_BLOCK_INACTIVE ):
            block_users_in_list( 'inactive', inactive_users_list )
        elif ( _args.action == ACTION_BLOCK_ORPHAN ):
            block_users_in_list( 'orphan', real_orphan_users_list )
        else:
            do_fun.trace_err( "Unknown action '%s' - exiting" % ( _args.action ) )
            sys.exit(1)


# -- MAIN ------------------------------------------------------------------- #

def main():

    init()

    manage_users()

    do_fun.trace_dbg()
    do_fun.trace_dbg( "DONE" )
    do_fun.trace_nrm()

# --------------------------------------------------------------------------- #

if __name__ == "__main__":
    main()

# --------------------------------------------------------------------------- #
