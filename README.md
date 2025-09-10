# Managed-Folders
Manage-Zips.ps1 automates ZIP archive handling: it scans a directory (default: current folder), checks for matching .zip/folder pairs, moves coexisting zips to ./Done, extracts zips without folders then moves them to Done, and leaves unzipped-only folders untouched. Supports optional -SourceDir and -DoneDir parameters.


Features
- Detects Coexisting items (both Name.zip and Name\) and moves the .zip to Done/.
- Finds ZippedOnly items (only Name.zip), extracts them, then moves the archive to Done/.
- Leaves UnzippedOnly folders untouched.
- Default behavior works in the script’s own folder—no parameters required.
- Safe by default: checks before unzipping or moving, and won’t overwrite existing files.

Prerequisites
- Windows PowerShell 5.0 or later
- Execution policy allowing script execution (e.g. RemoteSigned or use the Bypass flag)

Installation
- Clone or download this repo.
- Place Manage-Zips.ps1 wherever you want to run it.

Usage
From the folder containing Manage-Zips.ps1:
# Default: scans current directory, moves zips to ./Done
.\Manage-Zips.ps1

# Custom source directory and custom Done folder name
.\Manage-Zips.ps1 -SourceDir 'F:\Music\2025\House' -DoneDir 'Processed'


How It Works
- Setup
- Ensures DoneDir exists.
- Loads Expand-Archive if necessary.
- Scan & Classify
- For each .zip in SourceDir, it checks if a same-named folder exists.
- Classified as Coexisting or ZippedOnly.
- Action
- Coexisting: moves the zip to DoneDir.
- ZippedOnly: unzips into SourceDir, then moves the zip to DoneDir.

“Script-Module” Mode (Optional)
If you’d prefer to Import-Module instead of calling the .ps1 directly:
- Rename Manage-Zips.ps1 → Manage-Zips.psm1.
- Place it in:
%UserProfile%\Documents\WindowsPowerShell\Modules\Manage-Zips\Manage-Zips.psm1
- Then in any session:
Import-Module Manage-Zips
Manage-Zips -SourceDir 'D:\Your\Folder'



Feel free to file issues or PRs if you run into edge cases or have ideas for more features!
