#!/usr/bin/env bash
set -eu

# submit a Pull Request if files in the repo have changed
if [[ ! `git status --porcelain` ]]; then
    echo "No changes to commit."
    exit 0;
fi

git config --global user.email "${GITHUB_ACTOR}"
git config --global user.name "${GITHUB_ACTOR}@users.noreply.github.com"
git add -u
git commit -m "Bumped documentation & installation docs."
git push -fu origin bump-documentation-to-latest-versions
echo "::set-output name=updated_branch::bump-documentation-to-latest-versions"