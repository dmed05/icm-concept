# Session Notes

Session summaries preserve decisions and next actions independently of chat history.

When resuming work, read the most recent dated summary after `AGENTS.md` and `CONTEXT.md`.

This managed workspace uses `.git-data/` for repository metadata because the environment reserves `.git/` as an immutable placeholder. Use `scripts/git-local` in place of `git`, for example:

```bash
scripts/git-local status
scripts/git-local log --oneline
```
