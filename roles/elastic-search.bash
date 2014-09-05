#!/bin/bash -e

function main()
{
    local appPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    "${appPath}/essential.bash"

    "${appPath}/../cookbooks/elastic-search/recipes/install.bash"
}

main "${@}"