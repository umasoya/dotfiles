# Recording cmd history, if REC_STATUS is truely
hook_history_rec() {
  # recモードで､直前のコマンドが成功しているときのみ保存
  if [[ ${REC_STATUS} != "" ]] && [[ $? -neq 0 ]]; then
    echo -n ${1} >> ${REC_DIR:-/var/tmp/}${FILENAME}
  fi
}
# add-zsh-hook zshaddhistory hook_history_rec

rec() {
    if [[ ${REC_STATUS} = "" ]]; then
        export REC_STATUS=`date +'%Y%m%d%H%M%S'`
        RPROMPT="${fg[red]}REC${reset_color}"
    else
        export REC_STATUS=""
        RPROMPT=""
    fi
}