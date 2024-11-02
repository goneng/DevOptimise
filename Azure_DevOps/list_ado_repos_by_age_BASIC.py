#!/usr/bin/env python3

# List Git repositories in Azure DevOps, ordered by their last modified date

#TODO: Replace 'YOUR_PERSONAL_ACCESS_TOKEN', 'YOUR_ORGANIZATION_NAME', and 'YOUR_PROJECT_NAME' with your actual Azure DevOps details.

import requests
from operator import itemgetter

# Personal Access Token (PAT) for authentication
pat = 'YOUR_PERSONAL_ACCESS_TOKEN'

# Your Azure DevOps organization name and project name
organization = 'YOUR_ORGANIZATION_NAME'
project = 'YOUR_PROJECT_NAME'

# Construct the URL for the Repositories REST API
url = f'https://dev.azure.com/{organization}/{project}/_apis/git/repositories?api-version=6.0'

# Set up the headers for the REST API call
headers = {
    'Authorization': f'Basic {pat}'
}

# Make the REST API call to get the list of repositories
response = requests.get(url, headers=headers)

# Check if the call was successful
if response.status_code == 200:
    repos = response.json()['value']

    # List to hold repository details
    repo_details = []

    # Iterate through the repositories to get the last commit date
    for repo in repos:
        # Construct the URL for the Commits REST API
        commits_url = f'https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repo["id"]}/commits?api-version=6.0'

        # Make the REST API call to get the list of commits
        commits_response = requests.get(commits_url, headers=headers)

        if commits_response.status_code == 200:
            commits = commits_response.json()['value']
            if commits:
                # Get the most recent commit
                last_commit = commits
                # Add the repository name and last commit date to the list
                repo_details.append({
                    'name': repo['name'],
                    'last_commit_date': last_commit['committer']['date']
                })

    # Sort the repositories by last commit date
    sorted_repos = sorted(repo_details, key=itemgetter('last_commit_date'), reverse=True)

    # Print the sorted list of repositories
    for repo in sorted_repos:
        print(f"Repository: {repo['name']}, Last Modified: {repo['last_commit_date']}")

else:
    print('Failed to retrieve repositories')

