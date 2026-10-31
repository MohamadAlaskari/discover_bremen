# Builds the submission zip. Run it from anywhere:
#   powershell -ExecutionPolicy Bypass -File tool\make_submission.ps1
#
# submission\lib_pubspec_assets.zip  lib/ + pubspec.yaml + assets/ + README.md
#                                    (the README says how to run it)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$root = (Get-Location).Path
New-Item -ItemType Directory -Force submission | Out-Null
Remove-Item submission\*.zip -Force -ErrorAction SilentlyContinue

# Compress-Archive in Windows PowerShell 5.1 stores paths as "lib\main.dart",
# and macOS unpacks those as flat files. So the entries are written by hand
# with "/", as the zip format expects.
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
function New-Zip([string]$zipPath, [string]$base, [string[]]$items) {
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

Get-ChildItem submission\*.zip | Format-Table Name, Length
