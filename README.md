# Managed-Folders
Manage-Zips.ps1 automates ZIP archive handling: it scans a directory (default: current folder), checks for matching .zip/folder pairs, moves coexisting zips to ./Done, extracts zips without folders then moves them to Done, and leaves unzipped-only folders untouched. Supports optional -SourceDir and -DoneDir parameters.
