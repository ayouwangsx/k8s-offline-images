#!/bin/bash

if [-f ./VERSION]; then
    echo "🛑 VERSION file does not exist"
    exit 1
fi

if [ -f ./version_list ]; then
    rm -rf version_list
fi

cat VERSION | sort -Vu -o version_list

echo "Latest versions:"
cat version_list


cat version_list | while read version_list; do
    HAVE_TAG=false

    for tag in $(git tag); do
        if [ "${version_list}" == "${tag}" ]; then
            HAVE_TAG=true
            break
        fi
    done

    if ! ${HAVE_TAG}; then
        echo "Creating and pushing tag ${version_list}"
        git tag ${version_list}
        git push origin ${version_list}
    else
        echo "Tag ${version_list} already exists, skipping"
    fi
done