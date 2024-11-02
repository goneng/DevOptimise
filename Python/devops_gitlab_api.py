#!/usr/bin/env python3
# --------------------------------------------------------------------------- #
# DevOps GitLab API Utilities
# --------------------------------------------------------------------------- #

import requests
import sys
import json
from devops_fun import do_fun_trace_inf, do_fun_trace_err, do_fun_trace_dbg


def do_gitlab_api_block_user(user_id, token, server_url, verbose=False):
    """
    Block a GitLab user by ID
    """
    api_url = f"{server_url}/api/v4/users/{user_id}/block"

    if verbose:
        do_fun_trace_dbg(f"Blocking user {user_id} via: {api_url}")

    response = requests.post(
        api_url,
        headers={'PRIVATE-TOKEN': token}
    )

    if response.status_code == 201:
        if verbose:
            do_fun_trace_inf(f"Successfully blocked user {user_id}")
        return True
    else:
        do_fun_trace_err(f"Failed to block user {user_id}. Status: {response.status_code}")
        do_fun_trace_err(f"Response: {response.text}")
        return False


def do_gitlab_api_get_total_pages(api_url, token, verbose=False):
    """
    Get the total number of pages for a paginated GitLab API endpoint
    """
    if verbose:
        do_fun_trace_dbg(f"Getting total pages for: {api_url}")

    # Make a HEAD request to get pagination info without downloading data
    response = requests.head(
        api_url,
        headers={'PRIVATE-TOKEN': token}
    )

    if response.status_code == 200:
        total_pages = response.headers.get('X-Total-Pages', '1')
        total_pages = int(total_pages)

        if verbose:
            total_items = response.headers.get('X-Total', 'unknown')
            do_fun_trace_dbg(f"Total pages: {total_pages}, Total items: {total_items}")

        return total_pages
    else:
        do_fun_trace_err(f"Failed to get pagination info. Status: {response.status_code}")
        do_fun_trace_err(f"URL: {api_url}")
        return 1


def do_gitlab_api_is_admin_token(token, server_url, verbose=False):
    """
    Check if the provided token has admin privileges
    """
    api_url = f"{server_url}/api/v4/user"

    if verbose:
        do_fun_trace_dbg(f"Checking admin privileges via: {api_url}")

    response = requests.get(
        api_url,
        headers={'PRIVATE-TOKEN': token}
    )

    if response.status_code == 200:
        user_info = response.json()
        is_admin = user_info.get('is_admin', False)

        if verbose:
            username = user_info.get('username', 'unknown')
            do_fun_trace_inf(f"Token belongs to user '{username}', admin: {is_admin}")

        if not is_admin:
            do_fun_trace_err("Token does not have admin privileges")
            sys.exit(1)

        return True
    else:
        do_fun_trace_err(f"Failed to verify token. Status: {response.status_code}")
        do_fun_trace_err(f"Response: {response.text}")
        sys.exit(1)
