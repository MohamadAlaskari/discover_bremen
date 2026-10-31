# Builds both submission zips. Run it from anywhere:
#   powershell -ExecutionPolicy Bypass -File tool\make_submission.ps1
#
# submission\lib.zip                 lib/ with the package-free SoundService
#                                    (use it if only lib/ may be uploaded)
# submission\lib_pubspec_assets.zip  lib/ + pubspec.yaml + assets/ + README.md
#                                    (sound version; the README says how to run it)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$root = (Get-Location).Path
New-Item -ItemType Directory -Force submission | Out-Null

# Compress-Archive in Windows PowerShell 5.1 stores paths as "lib\main.dart",
# and macOS unpacks those as flat files. So the entries are written by hand
# with "/", as the zip format expects.
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
function New-Zip([string]$zipPath, [string]$base, [string[]]$items) {
  Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
  $zip = [IO.Compression.ZipFile]::Open($zipPath, 'Create')
  try {
    foreach ($item in $items) {
      $path = Join-Path $base $item
      # -Recurse on a single file would also pick up same-named files below it.
      $files = if (Test-Path $path -PathType Container) {
        Get-ChildItem $path -Recurse -File
      } else {
        Get-Item $path
      }
      foreach ($file in $files) {
        $name = $file.FullName.Substring($base.Length + 1) -replace '\\', '/'
        [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
          $zip, $file.FullName, $name, 'Optimal')
      }
    }
  } finally {
    $zip.Dispose()
  }
}

New-Zip "$root\submission\lib_pubspec_assets.zip" $root `
  @('lib', 'pubspec.yaml', 'assets', 'README.md')

# Copy lib/ outside the project (the IDE would lock files inside it) and swap
# in the SoundService that needs no package.
$stage = Join-Path $env:TEMP 'discover_bremen_lib_only'
Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $stage | Out-Null
Copy-Item lib $stage -Recurse
Copy-Item docs\sound_service_lib_only.dart `
  (Join-Path $stage 'lib\services\sound_service.dart') -Force
New-Zip "$root\submission\lib.zip" (Get-Item $stage).FullName @('lib')
Remove-Item $stage -Recurse -Force

Get-ChildItem submission\*.zip | Format-Table Name, Length
