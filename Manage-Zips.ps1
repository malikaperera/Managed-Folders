<#
.SYNOPSIS
    Manages zipped and unzipped folders in a given directory.
.DESCRIPTION
    - If a .zip and a same-named folder coexist, the .zip is moved to Done.
    - If a .zip exists without its folder, it’s extracted and then moved to Done.
    - Unzipped-only folders are left untouched.
.PARAMETER SourceDir
    The root directory to scan (e.g. 'F:\Music\2025\House').
.PARAMETER DoneDir
    Name of the subfolder under SourceDir for processed .zip files. Defaults to 'Done'.
.EXAMPLE
    .\Manage-Zips.ps1 -SourceDir 'F:\Music\2025\House'
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()]
    [string]$SourceDir,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$DoneDir = 'Done'
)

function Ensure-Directory {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Verbose "Creating directory: $Path"
        New-Item -Path $Path -ItemType Directory | Out-Null
    }
}

function Get-ZipStatus {
    param(
        [Parameter(Mandatory)][System.IO.FileInfo]$ZipFile,
        [Parameter(Mandatory)][string]$RootDir
    )
    $base = [IO.Path]::GetFileNameWithoutExtension($ZipFile.Name)
    $folderPath = Join-Path $RootDir $base

    if (Test-Path $folderPath -PathType Container) {
        return 'Coexisting'
    } else {
        return 'ZippedOnly'
    }
}

# Ensure Expand-Archive is available
if (-not (Get-Command Expand-Archive -ErrorAction SilentlyContinue)) {
    Import-Module Microsoft.PowerShell.Archive
}

# Resolve paths
$root     = (Resolve-Path $SourceDir).Path
$donePath = Join-Path $root $DoneDir
Ensure-Directory -Path $donePath

# Process each .zip in the root
Get-ChildItem -Path $root -Filter '*.zip' -File | ForEach-Object {
    $zip    = $_
    $status = Get-ZipStatus -ZipFile $zip -RootDir $root

    switch ($status) {
        'Coexisting' {
            Write-Host "ZIP+Folder exist for '$($zip.Name)'. Moving ZIP to '$DoneDir'."
            Move-Item -Path $zip.FullName -Destination $donePath -Force
        }
        'ZippedOnly' {
            Write-Host "No folder for '$($zip.Name)'. Extracting then moving ZIP to '$DoneDir'."
            Expand-Archive -Path $zip.FullName -DestinationPath $root -Force
            Move-Item     -Path $zip.FullName -Destination $donePath -Force
        }
    }
}

Write-Host "All done! Processed zips are in '$donePath'."
