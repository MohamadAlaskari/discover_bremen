# Builds both submission zips. Run it from anywhere:
#   powershell -ExecutionPolicy Bypass -File tool\make_submission.ps1
#
# submission\lib.zip                 lib/ with the package-free SoundService
#                                    (use it if only lib/ may be uploaded)
# submission\lib_pubspec_assets.zip  lib/ + pubspec.yaml + assets/ + README.md
#                                    (sound version; the README says how to run it)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
New-Item -ItemType Directory -Force submission | Out-Null

Compress-Archive -Path lib, pubspec.yaml, assets, README.md `
  -DestinationPath submission\lib_pubspec_assets.zip -Force

# Copy lib/ outside the project (the IDE would lock files inside it) and swap
# in the SoundService that needs no package.
$stage = Join-Path $env:TEMP 'discover_bremen_lib_only'
Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $stage | Out-Null
Copy-Item lib $stage -Recurse
Copy-Item docs\sound_service_lib_only.dart `
  (Join-Path $stage 'lib\services\sound_service.dart') -Force
Compress-Archive -Path (Join-Path $stage 'lib') `
  -DestinationPath submission\lib.zip -Force
Remove-Item $stage -Recurse -Force

Get-ChildItem submission\*.zip | Format-Table Name, Length
