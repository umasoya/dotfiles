#!/bin/env bash

##
# @name env::ask_env
# @brief 動作環境をユーザーに選択させて､コード値を返す
# @return 選択された環境のコード値
##
env::ask_env() {
    # スクリプトファイル自身の場所を取得
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${script_dir}/../enum/env.sh"

    # OS名とコードの配列を作成
    local os_names=()
    local os_codes=()

    for os_key in "${!OS[@]}"; do
        local code=${OS[$os_key]}
        os_names+=("${OS_NAME[$code]}")
        os_codes+=("$code")
    done

    local PS3="Select your operating system: "
    select choice in "${os_names[@]}"; do
        if [[ -n "$choice" ]]; then
            # 選択されたインデックスに対応するOSコードを返す
            echo "${os_codes[$((REPLY-1))]}"
            return
        else
            echo "Invalid selection. Please try again." >&2
        fi
    done
}
