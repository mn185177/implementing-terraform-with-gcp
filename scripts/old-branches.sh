#!/bin/sh

ECHO='echo '
for branch in $(git branch -r | sed 's/^\s*//' | sed 's/^remotes\///' | grep -v 'master$\|qa$'); do
  if ! ( [[ -f "$branch" ]] || [[ -d "$branch" ]] ) && [[ "$(git log $branch --since "1 day ago" | wc -l)" -eq 0 ]]; then
    if [[ "$DRY_RUN" = "true" ]]; then
      ECHO="testing"
      local_branch_name=$(echo "$branch" | sed 's/remotes\/origin\///') && continue
      branch_owner=$(git branch --contains=$local_branch_name --format=' %(authorname)' --sort=authorname) && continue
      $ECHO  "${local_branch_name}" -- "${branch_owner}"
    fi
    #$ECHO git push origin --delete "${local_branch_name}"
  fi
done
