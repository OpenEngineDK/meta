#!/bin/bash

unset repos
while IFS=' ' read -r repo; do
    no_prefix=$(echo ${repo#openengine_code/})

    ./meta/convert.sh $no_prefix
    echo $no_prefix
done < <(find . -name "*.dist")
