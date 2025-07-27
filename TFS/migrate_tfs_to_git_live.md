# Live-Migration of FTS to Git(Lab) <!-- omit in toc -->

### Table of Contents <!-- omit in toc -->
- [Recommended Migration Strategy](#recommended-migration-strategy)
  - [1. Initial Migration with git-tfs](#1-initial-migration-with-git-tfs)
  - [2. Push to GitLab](#2-push-to-gitlab)
  - [3. Ongoing Sync Setup](#3-ongoing-sync-setup)
- [Alternative Tools](#alternative-tools)
- [Key Considerations](#key-considerations)
  - [History Preservation](#history-preservation)
  - [Branch Mapping](#branch-mapping)
  - [Large Repositories](#large-repositories)
  - [Conflict Resolution](#conflict-resolution)
- [Performing the Migration](#performing-the-migration)
  - [Listing Available Projects and Repositories](#listing-available-projects-and-repositories)
    - [1. Using TFS Command Line (tf.exe)](#1-using-tfs-command-line-tfexe)
    - [2. Using git-tfs for Discovery](#2-using-git-tfs-for-discovery)
    - [3. Using PowerShell with TFS APIs](#3-using-powershell-with-tfs-apis)
    - [4. Using REST API (TFS 2015+)](#4-using-rest-api-tfs-2015)
    - [5. Simple Discovery Script](#5-simple-discovery-script)
    - [Key Notes](#key-notes)
  - [Authentication Setup](#authentication-setup)
    - [1. Windows Authentication (Domain)](#1-windows-authentication-domain)
    - [2. Basic Authentication](#2-basic-authentication)
    - [3. Personal Access Token (PAT) - TFS 2017+](#3-personal-access-token-pat---tfs-2017)
    - [4. Credential Manager Setup](#4-credential-manager-setup)
  - [Output Parsing](#output-parsing)
    - [1. PowerShell Scripts for Parsing](#1-powershell-scripts-for-parsing)
    - [2. Bash Scripts for Linux/Mac](#2-bash-scripts-for-linuxmac)
    - [3. Complete Discovery Script](#3-complete-discovery-script)
    - [4. Usage Examples](#4-usage-examples)
    - [5. Error Handling](#5-error-handling)

&nbsp;

For migrating TFVC to GitLab, I recommend **git-tfs** as the primary tool. It's specifically designed for this scenario and handles history preservation well.

## Recommended Migration Strategy

### 1. Initial Migration with git-tfs

Install git-tfs:
```bash
# Windows
choco install gittfs
# Or download from GitHub releases
```

Basic migration command:
```bash
git tfs clone http://tfs-server:8080/tfs/DefaultCollection $/YourProject/YourBranch local-repo
```

For branch migration:
```bash
# Clone with all branches
git tfs clone http://tfs-server:8080/tfs/DefaultCollection $/YourProject --branches=all

# Or specific branches
git tfs branch --init $/YourProject/BranchName
```

### 2. Push to GitLab

```bash
cd local-repo
git remote add origin https://gitlab.com/your-group/your-project.git
git push -u origin --all
git push -u origin --tags
```

### 3. Ongoing Sync Setup

For active repositories, create a sync script:

```bash
#!/bin/bash
# sync-tfs-gitlab.sh

cd /path/to/local-repo
git tfs fetch
git push origin --all
git push origin --tags
```

Schedule with cron:
```bash
# Daily sync at 2 AM
0 2 * * * /path/to/sync-tfs-gitlab.sh
```

&nbsp;

## Alternative Tools

- **Azure DevOps Migration Tools**: \
   Better for TFS→ADO, includes work items
- **git-tf**: \
   Microsoft's tool, but less maintained than git-tfs
- **TFS Integration Platform**: \
   For complex scenarios with bidirectional sync

&nbsp;

## Key Considerations

### History Preservation

git-tfs maintains commit history, timestamps, and authors. Each TFS changeset becomes a Git commit.

### Branch Mapping

Map TFS branches to Git branches early. Use `--branches=all` or specify branches individually.

### Large Repositories

For repos >2GB, consider using `--fetch-all` and `--authors` file for proper attribution.

### Conflict Resolution

Test migration on a subset first. Some TFS-specific features (labels, shelvesets) won't translate directly.

&nbsp;

## Performing the Migration

### Listing Available Projects and Repositories

To list all available projects and repositories on your TFS server, you have several options:

#### 1. Using TFS Command Line (tf.exe)

```bash
# List all team project collections
tf collections /server:http://tfs-server:8080/tfs

# List all projects in a collection
tf projects /collection:http://tfs-server:8080/tfs/DefaultCollection

# List all source control folders in a project
tf dir $/ProjectName /recursive /server:http://tfs-server:8080/tfs/DefaultCollection
```

#### 2. Using git-tfs for Discovery

```bash
# List all projects in a collection
git tfs list-remote-branches http://tfs-server:8080/tfs/DefaultCollection

# Get detailed info about branches in a specific project
git tfs list-remote-branches http://tfs-server:8080/tfs/DefaultCollection $/ProjectName
```

#### 3. Using PowerShell with TFS APIs

```powershell
# Load TFS assemblies
Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Client.dll"
Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.VersionControl.Client.dll"

# Connect to TFS
$tfsUri = "http://tfs-server:8080/tfs/DefaultCollection"
$tfs = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($tfsUri)
$vcs = $tfs.GetService([Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer])

# List all projects
$projects = $vcs.GetAllTeamProjects($false)
$projects | Select-Object Name, ServerItem

# List branches in each project
foreach($project in $projects) {
    Write-Host "Project: $($project.Name)"
    $branches = $vcs.QueryRootBranchObjects([Microsoft.TeamFoundation.VersionControl.Client.RecursionType]::Full)
    $branches | Where-Object { $_.Properties.RootItem.Item.StartsWith($project.ServerItem) } | Select-Object Properties
}
```

#### 4. Using REST API (TFS 2015+)

```bash
# List collections
curl -u username:password "http://tfs-server:8080/tfs/_apis/projectcollections?api-version=1.0"

# List projects in a collection
curl -u username:password "http://tfs-server:8080/tfs/DefaultCollection/_apis/projects?api-version=1.0"

# List repositories (if using Git repos in TFS)
curl -u username:password "http://tfs-server:8080/tfs/DefaultCollection/ProjectName/_apis/git/repositories?api-version=1.0"
```

#### 5. Simple Discovery Script

Create a batch file for quick discovery:

```batch
@echo off
echo === TFS Server Discovery ===
echo.
echo Collections:
tf collections /server:http://tfs-server:8080/tfs
echo.
echo Projects in DefaultCollection:
tf projects /collection:http://tfs-server:8080/tfs/DefaultCollection
echo.
echo Main branches:
for /f "tokens=*" %%i in ('tf projects /collection:http://tfs-server:8080/tfs/DefaultCollection') do (
    echo Checking project: %%i
    tf dir $/%%i /folders /server:http://tfs-server:8080/tfs/DefaultCollection
)
```

#### Key Notes

- Replace `http://tfs-server:8080/tfs` with your actual TFS server URL
- You may need authentication: add `/login:username,password` to tf commands
- For HTTPS servers, ensure certificates are trusted
- Some commands require TFS Power Tools or Visual Studio Team Explorer

**Recommended approach**: Start with `tf collections` and `tf projects`, then use `git tfs list-remote-branches` for detailed branch information once you identify the projects you want to migrate.

&nbsp;

### Authentication Setup

#### 1. Windows Authentication (Domain)
If your TFS uses Windows Authentication:

```bash
# tf.exe will use current Windows credentials automatically
tf projects /collection:http://tfs-server:8080/tfs/DefaultCollection

# For git-tfs (uses current Windows user)
git tfs list-remote-branches http://tfs-server:8080/tfs/DefaultCollection
```

#### 2. Basic Authentication
For username/password authentication:

```bash
# tf.exe with explicit credentials
tf projects /collection:http://tfs-server:8080/tfs/DefaultCollection /login:username,password

# git-tfs with credentials
git tfs list-remote-branches http://username:password@tfs-server:8080/tfs/DefaultCollection
```

#### 3. Personal Access Token (PAT) - TFS 2017+
```bash
# Use PAT as password with any username
tf projects /collection:http://tfs-server:8080/tfs/DefaultCollection /login:anyuser,your-pat-token

# git-tfs with PAT
git tfs list-remote-branches http://anyuser:your-pat-token@tfs-server:8080/tfs/DefaultCollection
```

#### 4. Credential Manager Setup
Store credentials securely:

```bash
# Windows Credential Manager
cmdkey /add:tfs-server:8080 /user:domain\username /pass:password

# Git credential manager
git config --global credential.helper manager-core
```

&nbsp;

### Output Parsing

#### 1. PowerShell Scripts for Parsing

**Parse tf projects output:**
```powershell
# get-tfs-projects.ps1
param(
    [string]$TfsUrl = "http://tfs-server:8080/tfs/DefaultCollection",
    [string]$Credentials = ""
)

$loginParam = if ($Credentials) { "/login:$Credentials" } else { "" }

# Get projects and parse output
$projectsOutput = & tf projects /collection:$TfsUrl $loginParam 2>&1
$projects = @()

foreach ($line in $projectsOutput) {
    if ($line -match "^\$\/([^\/]+)") {
        $projects += $matches[1]
    }
}

# Output as objects
$projects | ForEach-Object {
    [PSCustomObject]@{
        ProjectName = $_
        ServerPath = "`$/$_"
        TfsUrl = $TfsUrl
    }
} | Export-Csv -Path "tfs-projects.csv" -NoTypeInformation

Write-Host "Found $($projects.Count) projects"
$projects
```

**Parse branch information:**
```powershell
# get-tfs-branches.ps1
param(
    [string]$TfsUrl = "http://tfs-server:8080/tfs/DefaultCollection",
    [string]$ProjectName,
    [string]$Credentials = ""
)

$loginParam = if ($Credentials) { "/login:$Credentials" } else { "" }

# Get branches using git-tfs
$branchesOutput = & git tfs list-remote-branches $TfsUrl "`$/$ProjectName" 2>&1
$branches = @()

foreach ($line in $branchesOutput) {
    if ($line -match "TFS branches that could be cloned:") { continue }
    if ($line -match "^\s+(\$\/[^\s]+)\s+(.*)$") {
        $branches += [PSCustomObject]@{
            Project = $ProjectName
            BranchPath = $matches[1].Trim()
            Description = $matches[2].Trim()
        }
    }
}

$branches | Export-Csv -Path "tfs-branches-$ProjectName.csv" -NoTypeInformation
$branches
```

#### 2. Bash Scripts for Linux/Mac

**Parse projects (Bash):**
```bash
#!/bin/bash
# parse-tfs-projects.sh

TFS_URL="http://tfs-server:8080/tfs/DefaultCollection"
CREDENTIALS="" # format: "username,password"

# Function to get projects
get_projects() {
    local login_param=""
    if [ ! -z "$CREDENTIALS" ]; then
        login_param="/login:$CREDENTIALS"
    fi

    tf projects /collection:$TFS_URL $login_param 2>/dev/null | \
    grep -E '^\$\/' | \
    sed 's/\$\///g' | \
    awk '{print $1}' | \
    sort -u
}

# Create CSV output
echo "ProjectName,ServerPath,TfsUrl" > tfs-projects.csv

get_projects | while read project; do
    echo "$project,\$/$project,$TFS_URL" >> tfs-projects.csv
    echo "Found project: $project"
done

echo "Projects saved to tfs-projects.csv"
```

**Parse git-tfs branches output:**
```bash
#!/bin/bash
# parse-tfs-branches.sh

parse_branches() {
    local project=$1
    local tfs_url=$2

    echo "ProjectName,BranchPath,LastCommit" > "tfs-branches-$project.csv"

    git tfs list-remote-branches "$tfs_url" "\$/$project" 2>/dev/null | \
    grep -E '^\s+\$\/' | \
    while read line; do
        branch_path=$(echo "$line" | awk '{print $1}')
        last_commit=$(echo "$line" | cut -d' ' -f2-)
        echo "$project,$branch_path,$last_commit" >> "tfs-branches-$project.csv"
        echo "Found branch: $branch_path"
    done
}

# Usage: ./parse-tfs-branches.sh ProjectName http://tfs-server:8080/tfs/DefaultCollection
parse_branches "$1" "$2"
```

#### 3. Complete Discovery Script

```powershell
# complete-tfs-discovery.ps1
param(
    [string]$TfsServer = "http://tfs-server:8080/tfs",
    [string]$Credentials = ""
)

$loginParam = if ($Credentials) { "/login:$Credentials" } else { "" }
$results = @()

# Get collections
Write-Host "Discovering collections..."
$collectionsOutput = & tf collections /server:$TfsServer $loginParam 2>&1
$collections = $collectionsOutput | Where-Object { $_ -match "http" } | ForEach-Object { $_.Trim() }

foreach ($collection in $collections) {
    Write-Host "Processing collection: $collection"

    # Get projects in collection
    $projectsOutput = & tf projects /collection:$collection $loginParam 2>&1
    $projects = $projectsOutput | Where-Object { $_ -match "^\$\/" } | ForEach-Object {
        ($_ -replace "^\$\/", "").Trim()
    }

    foreach ($project in $projects) {
        Write-Host "  Analyzing project: $project"

        # Get branches
        try {
            $branchesOutput = & git tfs list-remote-branches $collection "`$/$project" 2>&1
            $branchCount = ($branchesOutput | Where-Object { $_ -match "^\s+\$\/" }).Count
        } catch {
            $branchCount = "Unknown"
        }

        # Get latest changeset info
        try {
            $historyOutput = & tf history "`$/$project" /recursive /stopafter:1 /collection:$collection $loginParam 2>&1
            $latestChangeset = ($historyOutput | Where-Object { $_ -match "^\d+" } | Select-Object -First 1).Split()[0]
        } catch {
            $latestChangeset = "Unknown"
        }

        $results += [PSCustomObject]@{
            Collection = $collection
            Project = $project
            ServerPath = "`$/$project"
            BranchCount = $branchCount
            LatestChangeset = $latestChangeset
        }
    }
}

# Export results
$results | Export-Csv -Path "tfs-complete-discovery.csv" -NoTypeInformation
$results | Format-Table -AutoSize

Write-Host "`nDiscovery complete. Results saved to tfs-complete-discovery.csv"
Write-Host "Total projects found: $($results.Count)"
```

#### 4. Usage Examples

```bash
# Run complete discovery
./complete-tfs-discovery.ps1 -TfsServer "http://tfs-server:8080/tfs" -Credentials "domain\user,password"

# Parse specific project
./parse-tfs-branches.sh "MyProject" "http://tfs-server:8080/tfs/DefaultCollection"

# Use output for migration planning
$projects = Import-Csv "tfs-complete-discovery.csv"
$projects | Where-Object { $_.BranchCount -gt 1 } | ForEach-Object {
    Write-Host "Project $($_.Project) has multiple branches - plan accordingly"
}
```

#### 5. Error Handling

Add error handling to your scripts:

```powershell
try {
    $output = & tf projects /collection:$TfsUrl $loginParam 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "TF command failed: $output"
        return
    }
} catch {
    Write-Error "Authentication failed or TFS unreachable: $($_.Exception.Message)"
    return
}
```

These scripts will help you systematically discover and catalog your TFS structure before migration. Would you like me to explain any specific part in more detail?

&nbsp;

---

&nbsp;
