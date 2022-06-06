#!/usr/bin/env sh
# Update the version number in the documentation with the latest version tagged
# on the repository.
set -o errexit
set -o pipefail
set -o nounset

update_version() {
    INPUT_REPOSITORY = $1
    INPUT_VERSION_IDENTIFIER = $2

    LATEST_VERSION_TAG=`curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${INPUT_REPOSITORY}/releases/latest | jq --raw-output ".tag_name"` 
    LATEST_VERSION_NUMBER=${LATEST_VERSION_TAG:1}

    while read -r file; do
        echo "updating ${INPUT_REPOSITORY} version to ${LATEST_VERSION_NUMBER} in ${file}"
        CURRENT_VERSION_TAG=`awk "/${INPUT_VERSION_IDENTIFIER}/{print \\$2; exit;}" "${file}"`
        CURRENT_VERSION_NUMBER=${CURRENT_VERSION_TAG:1}
        sed -E -i "s/$CURRENT_VERSION_NUMBER/$LATEST_VERSION_NUMBER/g" ${file}
    done <<< "$(grep "${INPUT_VERSION_IDENTIFIER}" ./docs -R --files-with-matches)"
}

update_version ipfs/ipfs-update current-ipfs-updater-version
update_version ipfs/ipfs-cluster current-ipfs-cluster-version
update_version ipfs/go-ipfs current-ipfs-version
