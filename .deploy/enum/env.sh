#!/bin/env bash
# namespace: OS

# OS･Distributionをenum定義

declare -grA OS=(
    # Debian系
    [UBUNTU]=10

    # Red Hat系
    [AL2023]=20
    [ROCKY]=21
    [ALMA]=22

    # MacOS
    [MACOS]=50
)

declare -grA OS_NAME=(
    [${OS[UBUNTU]}]="Ubuntu"
    [${OS[AL2023]}]="Amazon Linux 2023"
    [${OS[ROCKY]}]="Rocky Linux"
    [${OS[ALMA]}]="AlmaLinux"
    [${OS[MACOS]}]="MacOS"
)

##
# @name os::get_code
# @brief OS名からOSコードを取得する
# @param $1 OS名（OSのキー名）
# @return OSコード（見つからない場合は -1）
# @example
#   code=$(os::get_code "UBUNTU")
#   echo $code  # 10
##
os::get_code() {
    local os_name=$1
    echo "${OS[${os_name}]:- -1}"
}

##
# @name os::get_name
# @brief OSコードからOS名を取得する
# @param $1 OSコード
# @return OS名（見つからない場合は "Unknown"）
# @example
#   name=$(os::get_name 10)
#   echo $name  # Ubuntu
##
os::get_name() {
    local os_code=$1
    echo "${OS_NAME[${os_code}]:-Unknown}"
}
