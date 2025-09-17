<#
Batch re-encode MP3 files in the project using ffmpeg.

Usage (PowerShell):
  cd <repo-root>
  .\scripts\reencode-mp3s.ps1 -InputDir "src/main/webapp/musicStore/sound" -OutputDir "src/main/webapp/musicStore/compressed" -Bitrate "96k"

Requirements:
 - ffmpeg must be installed and available on PATH: https://ffmpeg.org/

This script will preserve subdirectories and create compressed copies (it will not overwrite originals).
#>

param(
    [string]$InputDir = "src/main/webapp/musicStore/sound",
    [string]$OutputDir = "src/main/webapp/musicStore/compressed",
    [string]$Bitrate = "96k",
    [int]$SampleRate = 44100,
    [int]$Channels = 2
)

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Error "ffmpeg not found. Install ffmpeg and ensure it's on PATH. See https://ffmpeg.org/"
    exit 1
}

$inputPath = Join-Path (Get-Location) $InputDir
$outputPath = Join-Path (Get-Location) $OutputDir

if (-not (Test-Path $inputPath)) {
    Write-Error "Input directory '$inputPath' does not exist."
    exit 1
}

Write-Host "Input: $inputPath"
Write-Host "Output: $outputPath"
Write-Host "Bitrate: $Bitrate, SampleRate: $SampleRate, Channels: $Channels"

Get-ChildItem -Path $inputPath -Recurse -Filter *.mp3 | ForEach-Object {
    $relPath = $_.FullName.Substring($inputPath.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
    $destFile = Join-Path $outputPath $relPath
    $destDir = Split-Path $destFile -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

    # Use ffmpeg to re-encode
    $args = @('-y', '-i', $_.FullName, '-ac', $Channels.ToString(), '-ar', $SampleRate.ToString(), '-b:a', $Bitrate, $destFile)
    Write-Host "Re-encoding: $relPath -> $destFile"
    $proc = Start-Process -FilePath ffmpeg -ArgumentList $args -NoNewWindow -Wait -PassThru
    if ($proc.ExitCode -ne 0) {
        Write-Warning "ffmpeg failed for file: $($_.FullName) (exit $($proc.ExitCode))"
    }
}

Write-Host "Done. Compressed files are in: $outputPath"
