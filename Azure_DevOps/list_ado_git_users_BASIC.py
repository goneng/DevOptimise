import requests
import base64
import json

# Define your Azure DevOps organization, project, and personal access token (PAT)
organization = "yourOrganization"  # Replace with your organization name
project = "yourProjectName"         # Replace with your project name
pat = "yourPAT"                     # Replace with your PAT

# Encode PAT for authorization header
credentials = base64.b64encode(f":{pat}".encode("ascii")).decode("ascii")
headers = {
    "Authorization": f"Basic {credentials}",
    "Content-Type": "application/json"
}

# Function to get all repositories in a project
def get_repositories():
    url = f"https://dev.azure.com/{organization}/{project}/_apis/git/repositories?api-version=7.1-preview.1"
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()["value"]
    else:
        print(f"Failed to get repositories: {response.status_code}, {response.text}")
        return []

# Function to get permissions for a repository
def get_repository_permissions(repository_id):
    url = f"https://dev.azure.com/{organization}/_apis/securitynamespaces/repositories/{repository_id}/permissions?api-version=7.1-preview.1"
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()["value"]
    else:
        print(f"Failed to get permissions for repo {repository_id}: {response.status_code}, {response.text}")
        return []

# Get all repositories in the project
repositories = get_repositories()

# Loop through each repository and get user permissions
for repo in repositories:
    print(f"\nRepository: {repo['name']} (ID: {repo['id']})")
    permissions = get_repository_permissions(repo['id'])

    # Print the permissions
    for permission in permissions:
        print(f"User/Group: {permission['displayName']} - {permission['role']}")

