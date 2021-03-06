#!/bin/bash -e

function refreshUpdateCenter()
{
    umask '0022'

    # Validate Jenkins Config Folder

    if [[ "$(isEmptyString "${JENKINS_INSTALL_FOLDER_PATH}")" = 'true' ]]
    then
        JENKINS_INSTALL_FOLDER_PATH="$(getUserHomeFolder "${JENKINS_USER_NAME}")/.jenkins"
    fi

    checkExistFolder "${JENKINS_INSTALL_FOLDER_PATH}"

    # Validate JSON Content

    local updateInfo=''
    updateInfo="$(getRemoteFileContent "${JENKINS_UPDATE_CENTER_URL}")"
    updateInfo="$(sed '1d;$d' <<< "${updateInfo}")"

    checkNonEmptyString "${updateInfo}" 'undefined content of update center url'

    # Update JSON File

    local -r jsonFilePath="${JENKINS_INSTALL_FOLDER_PATH}/updates/default.json"
    local -r updateFolderPath="$(dirname "${jsonFilePath}")"

    mkdir -p "${updateFolderPath}"
    echo "${updateInfo}" > "${jsonFilePath}"
    chown -R "${JENKINS_USER_NAME}:${JENKINS_GROUP_NAME}" "${updateFolderPath}"
    info "Updated '${jsonFilePath}'"

    umask '0077'
}

function main()
{
    source "$(dirname "${BASH_SOURCE[0]}")/../../../libraries/util.bash"
    source "$(dirname "${BASH_SOURCE[0]}")/../attributes/default.bash"

    checkRequireLinuxSystem
    checkRequireRootUser

    header 'REFRESHING MASTER UPDATE CENTER JENKINS'

    refreshUpdateCenter
    installCleanUp
}

main "${@}"