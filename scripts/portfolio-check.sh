#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

errors=0

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  errors=$((errors + 1))
}

if [[ ! -f README.md ]]; then
  fail 'README.md is required.'
else
  grep -Eqi '^## (What I Built|Why I [Bb]uilt [Ii]t)[[:space:]]*$' README.md ||
    fail 'README must explain what you built.'
  grep -Eqi '^## (Operational [Ii]mpact|How It Supports( My)? Operations|How It Supports Operational Work)[[:space:]]*$' README.md ||
    fail 'README must explain operational impact.'
  grep -Eqi '^## My [Rr]ole( and [Dd]esign [Dd]ecisions)?[[:space:]]*$' README.md ||
    fail 'README must explain your role and design decisions.'
  grep -Eqi 'privacy|private|synthetic' README.md ||
    fail 'README must state a privacy or synthetic-data boundary.'
fi

template_repo=false
if [[ "${GITHUB_REPOSITORY:-}" == 'dmed05/ai-project-template' ]] ||
   [[ "$(basename "$root")" == 'ai-project-template' ]]; then
  template_repo=true
fi

if [[ "$template_repo" == false ]]; then
  [[ ! -f .portfolio-template-marker ]] ||
    fail 'Remove .portfolio-template-marker after customizing the project.'
  if git grep -n -I 'REPLACE_ME' -- . ':!scripts/portfolio-check.sh' \
    >/tmp/portfolio-placeholders.txt 2>/dev/null; then
    cat /tmp/portfolio-placeholders.txt >&2
    fail 'Replace all REPLACE_ME placeholders before publishing.'
  fi
fi

if git grep -n -I -E 'dmediana742@gmail\.com|cpam\.v01@gmail\.com' -- . \
  ':!scripts/portfolio-check.sh' >/tmp/portfolio-private-email.txt 2>/dev/null; then
  cat /tmp/portfolio-private-email.txt >&2
  fail 'A private commit email appears in tracked file content.'
fi

if git grep -n -I -E '/home/[[:alnum:]_.-]+/|/Users/[[:alnum:]_.-]+/' -- . \
  ':!scripts/portfolio-check.sh' >/tmp/portfolio-private-path.txt 2>/dev/null; then
  cat /tmp/portfolio-private-path.txt >&2
  fail 'A private local filesystem path appears in tracked content.'
fi

secret_pattern='AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|github_pat_[A-Za-z0-9_]{20,}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]{10,}'
if git grep -n -I -E "$secret_pattern" -- . \
  ':!scripts/portfolio-check.sh' \
  ':!scripts/security-check.sh' \
  ':!src/security.mjs' >/tmp/portfolio-secrets.txt 2>/dev/null; then
  cat /tmp/portfolio-secrets.txt >&2
  fail 'A credential-shaped value appears in tracked content.'
fi

while IFS= read -r path; do
  lower="${path,,}"
  case "$lower" in
    .env|*/.env|*.key|*.pem|*.p12|*.pfx|accounts/*|*/accounts/*|customer-data/*|*/customer-data/*|production-data/*|*/production-data/*|private/*|*/private/*|calendar-exports/*|*/calendar-exports/*|source-documents/*|*/source-documents/*)
      fail "High-risk private-data path is tracked: $path"
      ;;
  esac
done < <(git ls-files)

commit_sha="${PORTFOLIO_COMMIT_SHA:-HEAD}"
author_email="$(git show -s --format='%ae' "$commit_sha")"
if [[ "$author_email" != *@users.noreply.github.com ]]; then
  fail "Commit author email must use GitHub noreply; found: $author_email"
fi

if ((errors > 0)); then
  printf 'Portfolio policy failed with %d error(s).\n' "$errors" >&2
  exit 1
fi

printf 'Portfolio policy checks passed.\n'
