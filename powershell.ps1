# oh-my-posh theme setup
oh-my-posh init pwsh --config 'C:\Users\Admin\AppData\Local\Programs\oh-my-posh\themes\sonicboom_dark.omp.json' | Invoke-Expression

# tab completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# havee your ever switch directory suddenly and forgot where you were and how to get back?
# this script will help you pop back to the previous directory you were in

# Define a stack to store directory changes
$directoryStack = New-Object System.Collections.Stack

# Create a function to override the 'cd' command
function Set-Location {
    param(
        [string]$Path
    )

    # Push the current directory onto the stack
    $directoryStack.Push((Get-Location).Path)

    # Change the directory using the actual 'Set-Location' command
    Microsoft.PowerShell.Management\Set-Location -Path $Path
}

# Set the 'cd' alias to point to our custom 'Set-Location' function
Set-Alias -Name dn -Value Set-Location

function f {
    if ($directoryStack.Count -gt 0) {
        $previousDir = $directoryStack.Pop()
        Set-Location -Path $previousDir
    }
    else {
        Write-Host "No directory to go back to."
    }
}

# see file contents in the terminal with syntax highlighting using fd, bat and fzf
function ff {fd --type f --exclude node_modules --exclude Lib | fzf  --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%}

# alias to cache all the Node Packages I have installed in my machine and list them with a refresh option
function fn {
    param (
        [string]$Command
    )
    
    $cacheFilePath = Join-Path -Path $env:TEMP -ChildPath "cached_directories.txt"

    if($Command -eq "--uc") {
        RefreshCache
    }

    # Check if the cached directory list exists
    if (-not (Test-Path -Path $cacheFilePath)) {
        # If the cached directory list doesn't exist, create it
        return
    }

    # Read the cached directory list
    $cachedDirectories = Get-Content -Path $cacheFilePath

    $selectedDirectory = $cachedDirectories | fzf

    if ($selectedDirectory) {
        $parentDirectory = Split-Path -Path $selectedDirectory -Parent
        $PparentDirectory = Split-Path -Path $parentDirectory -Parent
        Set-Location -Path $parentDirectory
        Write-Host "You are in $PparentDirectory project location"
    }
}

function RefreshCache {
    $ProjectsDirectory = @("D:/Projects/JAVASCRIPT", "D:/Self-Dev/NodeModules", "D:/Projects/Docker")
    $cacheFilePath = Join-Path -Path $env:TEMP -ChildPath "cached_directories.txt"

    $allDirectories = foreach ($directory in $ProjectsDirectory) {
        Get-ChildItem -Path $directory -Filter "node_modules" -Recurse -Directory | Get-ChildItem -Directory | Select-Object -ExpandProperty FullName -Unique
    }

    # Generate the directory list and save it to the cache file
    $allDirectories | Out-File -FilePath $cacheFilePath
    Write-Host "Cache updated successfully 🎇"
}

# an alias to the 'git switch' command, since I am using it more recently
function gs{
  param(
    [string]$Command
  )

  Invoke-Expression "git switch $Command"
}

# change to the directory you want to go to using fd and fzf
function fk {Set-Location (fd --type d --exclude node_modules --exclude Lib | fzf  --no-multi)}

# alias for cd .. to go back one directory
function i {Set-Location ..}

# shortcut to go to projects directory where i put all my projects
function p{Set-Location D:/Projects}

# shortcut to go to documents directory where i put my powershell config file
function s{Set-Location C:\Users\Admin\Documents\PowerShell}

# shortcut to go to nvim config directory where i put my nvim config file
function op{Set-Location C:\Users\Admin\AppData\Local\nvim}

# alias for cd ~ to go back to home directory
function d{Set-Location ~} 

# alias for revealing the directory in explorer
function al{explorer .}

# alias for clearing the terminal
function j{
  try {
      Clear-Host
  } catch {
      Write-Error $_.Exception.Message
    }
  }

# alias to open startup folder
function n{explorer "C:\Users\Admin\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"}

# alias to see git log in a pretty format
function jl{git log --oneline --graph --decorate --all}

# alias to create a new file in the current directory stolen from linux
function touch {
    try {
        New-Item $args
    } catch {
        Write-Error $_.Exception.Message
    }
}

# alias to open to open a directory in vs code
# function fj {
#     $selected_directory=$(fd --type d --exclude node_modules --exclude Lib | fzf --exit-0)
#     if ([string]::IsNullOrEmpty($selected_directory) -eq $false) {
#         & "code" "$selected_directory"
#     }
# }

# alias to open a directory in vs code and add an option to open the 10 most recent opened projects only
function fj {
    param (
        [switch]$Recent
    )

    $cacheFilePath = Join-Path -Path $env:TEMP -ChildPath "recent_projects.txt"
    $recentProjects = @()

    if (-not (Test-Path -Path $cacheFilePath)) {
        Write-Host "No recent projects found."
        return
    }

    $recentProjects = Get-Content -Path $cacheFilePath

    if ($Recent) {

        if($recentProjects.Length -eq 0) {
            Write-Host "You have 0 recent projects"
            return
        }

        $recentProjectsRev = $recentProjects[($recentProjects.Length-1)..0]

        $selectedDirectory = $recentProjectsRev | Select-Object -First 10 | fzf

        if ($selectedDirectory) {
            & "code" "$selectedDirectory"
        }
    }
    else {
        $selectedDirectory = $(fd --type d --exclude node_modules --exclude Lib | fzf --exit-0)

        if ([string]::IsNullOrEmpty($selectedDirectory) -eq $false) {
            & "code" "$selectedDirectory"

            $found = $recentProjects | Where-Object { $_ -eq $selectedDirectory }

            # Add the selected directory to the recent projects list if the selected directory is not found else make the selected directory the last entry
            if([string]::IsNullOrEmpty($found)) {
                $selectedDirectory | Out-File -FilePath $cacheFilePath -Append
            } else {
                $recentProjects = $recentProjects | Where-Object {$_ -ne $selectedDirectory}
                $recentProjects += $selectedDirectory
                $recentProjects | Out-File -FilePath $cacheFilePath
            }

        }
    }
}

# alias to open a file in note pad
function dk {
  $file = $(fd --type f --exclude node_modules --exclude Lib | fzf --preview 'bat --style=numbers --color=always {}')
  if ($file) {
    pwsh.exe -NoProfile -Command "Start-Process  -FilePath `"$file`""
  }
}

# alias to open lunar vim
Set-Alias lv 'C:\Users\Admin\.local\bin\lvim.ps1'

# alias to open any text file with note pad, lunar vim, visual studio code or nvim
function dd {
  # Prompt the user to choose an editor
  $selected_editor = $(Write-Output "lvim", "vscode", "nvim", "notepad" | fzf --prompt="Choose an editor: ")

  # Get the selected file and open it with the selected editor
  $file = $(fd --type f --exclude node_modules --exclude Lib | fzf --preview 'bat --style=numbers --color=always {}')
  if ($file) {
    switch ($selected_editor) {

      "lvim" {
        pwsh.exe -Command "lv `"$file`"" 
      }
      "vscode" {
        pwsh.exe -Command "code `"$file`"" 
      }
      "nvim" {
        pwsh.exe -Command "nvim `"$file`"" 
      }
      "notepad" {
        pwsh.exe -Command "notepad `"$file`"" 
      }
    }
  }
}

# alias for nvim
Set-Alias vn nvim

# alias to unzip a zip file using 7zip
function unzip {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string]$ZipFile
    )

    $ParentFolder = Split-Path $ZipFile -Parent
    $ZipFileName = [System.IO.Path]::GetFileNameWithoutExtension($ZipFile)
    $Destination = Join-Path -Path $ParentFolder -ChildPath $ZipFileName

    try {
        $arguments = "x `"$ZipFile`" -o`"$Destination`" -y"
        Start-Process -FilePath '7z.exe' -ArgumentList $arguments -Wait -NoNewWindow | Out-Null
        Write-Output "Successfully extracted '$ZipFile' to '$Destination'"
    } catch {
        Write-Error "Error occurred while extracting the zip file: $_"
    }
}

# alias to zip a folder using 7zip
function Zip {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]$FolderPath
    )

    $FolderName = [System.IO.Path]::GetFileName($FolderPath)
    $ZipFile = Join-Path -Path $FolderPath -ChildPath "$FolderName.zip"

    try {
        $arguments = "a -tzip `"$ZipFile`" `"$FolderPath\*`""
        Start-Process -FilePath '7z.exe' -ArgumentList $arguments -Wait -NoNewWindow | Out-Null
        Write-Output "Successfully created zip file '$ZipFile' from folder '$FolderPath'"
    } catch {
        Write-Error "Error occurred while creating the zip file: $_"
    }
}

