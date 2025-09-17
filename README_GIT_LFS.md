# Handling large MP3 files for GitHub

If your repository contains large MP3 files and GitHub rejects pushing them, you can use Git LFS (Large File Storage) or alternative approaches. This document shows how to set up Git LFS on Windows, track `*.mp3`, and migrate existing commits if needed.

Important: Back up your repository before performing history rewriting (migration).

1. Install Git LFS

- Windows (Git Bash or PowerShell):

  - Use the official installer: https://git-lfs.github.com/ and run it.
  - Or via Chocolatey (PowerShell as admin):

  ```powershell
  choco install git-lfs
  git lfs install
  ```

2. Track MP3 files

From the repository root:

```bash
git lfs install --system
git lfs track "*.mp3"
git add .gitattributes
git add src/main/webapp/musicStore/sound/**
git commit -m "Track mp3 files with Git LFS"
git push origin main
```

3. If the MP3 files were already committed and pushed (large files in history)

You must rewrite history so the large files are stored in LFS rather than plain Git. Two recommended options:

- Option A: Use `git lfs migrate` (simpler)

```bash
# Make sure you have committed your current work and pushed any branches you need to preserve.
git lfs migrate import --include="*.mp3" --include-ref=refs/heads/main
# Force push rewritten branch
git push --force origin main
```

- Option B: Use `git filter-repo` (faster and more flexible; requires installing the tool)

```bash
pip install git-filter-repo
git filter-repo --strip-blobs-bigger-than 10M
# Or use more specific file filters; follow filter-repo docs carefully.
```

Note: Rewriting history will change commit hashes — coordinate with collaborators.

4. Alternatives if you prefer not to use Git LFS

- Host large media externally (S3, DigitalOcean Spaces, Google Cloud Storage) and store only URLs in the repo.
- Use GitHub Releases: attach MP3 files as release assets and keep them out of the main repo.
- Use a separate storage-only repository that is not cloned by default.

5. Verifying LFS

After pushing, check that GitHub shows LFS usage on the repository page and that `git lfs ls-files` lists tracked files locally.

6. Troubleshooting

- If push fails with LFS quota errors, review GitHub LFS storage quotas (they may require a paid plan for large volumes).
- If some large files remain in history after migration, ensure you ran the migrate/import command correctly and forced a push.

If you'd like, I can:

- Add a branch-safe migration script to the repo that automates `git lfs migrate` for `*.mp3`.
- Remove the MP3s from the repo and add placeholders and a script to download them from an external storage during CI/deploy.
