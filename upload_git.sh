#!/bin/bash

# Github token
ACCESS_TOKEN=38d4313849eb31117759528792a9d7517f8fc6a0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

create_repo()
{
    curl -u skeen:$ACCESS_TOKEN https://api.github.com/orgs/OpenEngineDK/repos -d "{\"name\":\"$1\"}"
}

# Find all the darcs repositories and loop through them
unset repos
while IFS=' ' read -r repo; do
    no_prefix=$(echo ${repo#openengine_code/})
    repo_name=$(dirname "${no_prefix}")
    repo_dir=$(dirname "${repo}")
    git_name=$(echo $repo_name | sed "s#/#-#g")

    # Create repositories on github
    create_repo $repo_name

    # Setup the output folder
    output_folder=gitengine/$repo_name
    abs_folder=$(readlink -f $output_folder)

    # Create repository folders
    mkdir -p $output_folder
    cd $output_folder
    echo $output_folder
    git init
    cd $DIR

    # Export darcs repositories
    cd $repo_dir
    mkdir -p _darcs/pristine.hashed
    darcs convert export | (cd $abs_folder && git fast-import)
    if [ $? -eq 0 ]; then
        cd $DIR
        # Push repositories
        cd $output_folder
        git remote add origin git@github.com:OpenEngineDK/$git_name.git
        git push -u origin master
        if [ $? -ne 0 ]; then
            echo $repo_name >> ~/fail.txt
        fi
        #git remote set-url origin git@github.com:OpenEngineDK/$git_name.git
        #git push --force -u origin master
        cd $DIR
    else
        echo $repo_name >> ~/fail.txt
    fi
    cd $DIR
    
    #echo $no_prefix
    #echo $repo_name
    #echo $git_name
    #echo $repo
done < <(find openengine_code -name "_darcs" -type d)
