#!/bin/bash

COMMIT_MSG="Updated dependencies for git!"
WORK_PWD=$PWD
echo $WORK_PWD

unset repos
while IFS=' ' read -r repo; do
    abs_path=$(readlink -f $repo)
    abs_dir=$(dirname "${abs_path}")

    cd $abs_dir
    git add *.dist
    git commit -m "$COMMIT_MSG"
    git push
    cd $WORK_PWD

    echo $abs_path
    echo $abs_dir
done < <(find . -name "*.dist")
