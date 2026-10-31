# Builds the submission: the whole Flutter project in one zip, as the Google
# Form asks ("Send Flutter project - in a .zip file"). Run it from anywhere:
#   powershell -ExecutionPolicy Bypass -File tool\make_submission.ps1
#
# git archive packs exactly the committed files under one top folder,
# discover_bremen/, with "/" paths. build/, .dart_tool/ and other local
# folders are not committed, so they cannot end up in the zip.
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)

# The zip is built from the last commit, so unsaved work would be missing.
if (git status --porcelain) {
  throw 'Commit your changes first: the zip is built from the last commit.'
}

New-Item -ItemType Directory -Force submission | Out-Null
Remove-Item submission\*.zip -Force -ErrorAction SilentlyContinue
git archive --format=zip --prefix=discover_bremen/ `
  -o submission\discover_bremen.zip HEAD
if ($LASTEXITCODE) { throw 'git archive failed.' }

Get-ChildItem submission\*.zip | Format-Table Name, Length
