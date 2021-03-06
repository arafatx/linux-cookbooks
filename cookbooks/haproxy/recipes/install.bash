#!/bin/bash -e

function install()
{
    umask '0022'

    if [[ "${HAPROXY_VERSION}" != '1.4' ]]
    then
        info '\nadd-apt-repository'
        add-apt-repository -y "ppa:vbernat/haproxy-${HAPROXY_VERSION}"

        info '\napt-get update'
        apt-get update -m
    fi

    installPackages 'haproxy'

    # Enable Haproxy

    if [[ "${HAPROXY_VERSION}" = '1.4' ]]
    then
        echo 'ENABLED=1' > '/etc/default/haproxy'
    fi

    # Display Open Ports

    displayOpenPorts '5'

    # Display Version

    displayVersion "$(haproxy -vv 2>&1)"

    umask '0077'
}

function main()
{
    source "$(dirname "${BASH_SOURCE[0]}")/../../../libraries/util.bash"
    source "$(dirname "${BASH_SOURCE[0]}")/../attributes/default.bash"

    header 'INSTALLING HAPROXY'

    checkRequireLinuxSystem
    checkRequireRootUser

    install
    installCleanUp
}

main "${@}"