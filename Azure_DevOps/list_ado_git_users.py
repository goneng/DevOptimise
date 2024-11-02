#!/usr/bin/env python3
# --------------------------------------------------------------------------- #
# Manage Azure DevOps Users (List Users and Their Permissions in Repositories)
# --------------------------------------------------------------------------- #
# See
#  - 'Projects API'        https://learn.microsoft.com/en-us/rest/api/azure/devops/core/projects
#  - 'Repositories API'    https://learn.microsoft.com/en-us/rest/api/azure/devops/git/repositories
#  - 'Security Namespaces' https://learn.microsoft.com/en-us/rest/api/azure/devops/securitynamespaces
# --------------------------------------------------------------------------- #

from types import SimpleNamespace           # Used for 'struct' objects
import argparse                 # Parse command-line arguments
import json                     # Pretty-print JSON-like structures
import requests                 # Perform HTTP requests
from tabulate import tabulate   # Pretty-print table
import pandas as pd             # Python table

# Import SE-DevOps Utilities
import site
import sys
site.addsitedir("../Python/")
from devops_fun         import *
# from devops_gitlab_api  import *

# Constants ----------------------------------------------------------------- #

AZURE_DEVOPS_ORG = "your_organization"
AZURE_DEVOPS_PAT = "your_personal_access_token"

# Global Variables ---------------------------------------------------------- #

_args = argparse.Namespace()
_my   = SimpleNamespace()

# Functions ----------------------------------------------------------------- #

def get_projects(ado_org, ado_pat):
    projects_info_list = []

    url = f"https://dev.azure.com/{ado_org}/_apis/projects?api-version=7.0"
    response_projects = requests.get(url, auth=('', ado_pat))
    if ( response_projects.status_code == requests.codes.ok ):
        do_fun_trace_dbg( "Reading %s projects ..." % ( 'list_type' ) )
#       do_fun_trace_dbg( "Reading %s projects (page %2d of %d) ..." % ( list_type, page, users_total_pages ) )
        projects_info_list.extend( response_projects.json() )
    else:
        do_fun_trace_err( 'Failed to get %s users on: %s (Error: %s): ' %
                            ( 'list_type', url, response_projects.status_code ) )
        do_fun_trace_err( "projects_info_list:\n%s" % ( json.dumps( projects_info_list, indent=4 ) ) )
        sys.exit(1)
    response_projects.raise_for_status()
    return response_projects.json()['value']

def get_repositories(ado_org, project, ado_pat):
    url = f"https://dev.azure.com/{ado_org}/{project['name']}/_apis/git/repositories?api-version=7.0"
    response = requests.get(url, auth=('', ado_pat))
    response.raise_for_status()
    return response.json()['value']

def get_user_permissions(ado_org, project, repository_id, ado_pat):
    security_namespace_id = "repoV2"  # Security namespace ID for repositories
    url = f"https://dev.azure.com/{ado_org}/_apis/securitynamespaces/{security_namespace_id}/permissions?securityNamespaceId={security_namespace_id}&permissions=0&token={repository_id}&api-version=7.0"
    response = requests.get(url, auth=('', ado_pat))
    response.raise_for_status()
    return response.json()['value']

def list_users_permissions(ado_org, ado_pat):
    projects = get_projects(ado_org, ado_pat)
    user_permissions = []

    for project in projects:
        repositories = get_repositories(ado_org, project, ado_pat)
        for repo in repositories:
            permissions = get_user_permissions(ado_org, project, repo['id'], ado_pat)
            for permission in permissions:
                user_permissions.append({
                    'Project': project['name'],
                    'Repository': repo['name'],
                    'User': permission['principalName'],
                    'Permission': permission['displayName']
                })

    return user_permissions

def output_permissions(user_permissions):
    df = pd.DataFrame(user_permissions)
    df = df.sort_values(by=['Project', 'Repository', 'User'])
    print(tabulate(df, headers='keys', tablefmt='grid'))

def init():

    parser = argparse.ArgumentParser(description="List Azure DevOps Users and their Permissions in Repositories")
    parser.add_argument("-a", "--action",  help="Script Action", default='list')
    parser.add_argument("-o", "--ado_org", help="Azure DevOps organization", default=AZURE_DEVOPS_ORG)
    parser.add_argument("-p", "--ado_pat", help="Azure DevOps Personal Access Token", default=AZURE_DEVOPS_PAT)
    parser.add_argument("-v", "--verbose", help="Verbose mode", action="store_true")

    global _args
    _args = parser.parse_args()

def main():

    init()

    user_permissions = list_users_permissions(_args.ado_org, _args.ado_pat)

    output_permissions(user_permissions)

    if _args.verbose:
        print(json.dumps(user_permissions, indent=4))

# --------------------------------------------------------------------------- #

if __name__ == "__main__":
    main()

# --------------------------------------------------------------------------- #
