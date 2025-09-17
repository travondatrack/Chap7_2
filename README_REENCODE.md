# Re-encoding MP3s to reduce size

If your MP3 files are too large to push to GitHub, you can re-encode them at a lower bitrate to shrink size while preserving acceptable audio quality for distribution.

Files added:

- `scripts/reencode-mp3s.ps1` – PowerShell script that uses `ffmpeg` to re-encode all MP3s in `src/main/webapp/musicStore/sound` into a parallel `compressed` folder.

How it works

- The script keeps the directory structure and writes compressed copies to `src/main/webapp/musicStore/compressed` (it doesn't overwrite originals).
- Default bitrate is `96k` (96 kbps) which often provides good voice and reasonable music quality while being ~3–6x smaller than 320k files.

Install ffmpeg

- Windows: https://ffmpeg.org/download.html — add ffmpeg to PATH. Or use Chocolatey: `choco install ffmpeg`.
- macOS: `brew install ffmpeg`.
- Linux: `sudo apt install ffmpeg` or distro-specific package.

Example usage (PowerShell)

```powershell
cd <repo-root>
.\scripts\reencode-mp3s.ps1 -InputDir "src/main/webapp/musicStore/sound" -OutputDir "src/main/webapp/musicStore/compressed" -Bitrate "96k"
```

Recommended bitrates

- 128k — Good balance of quality and size for music.
- 96k — Smaller size, acceptable for low-to-medium quality audio.
- 64k — Use only for spoken-word audio where quality is less important.

Estimated size reductions (approximate)

- 320k -> 128k: ~40% of original size
- 320k -> 96k: ~30% of original size

After re-encoding

- Check the `compressed` folder; if you like the quality, you can replace originals or update your app to read from `compressed` directory.
- If you plan to commit the compressed files, consider using Git LFS (see `README_GIT_LFS.md`) or keeping media out of the repo and using external hosting.

Automation and CI

- You can add this script to CI to generate compressed audio artifacts and publish them to a release or artifact store, instead of committing large binary files to Git.

If you'd like, I can:

- Add a script to automatically replace originals with compressed files (with an undo backup).
- Add a small summary report that prints original vs compressed sizes and total savings.
