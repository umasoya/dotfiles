#local script_dir=$DOT_DIR/bin/build
#local targets=(vim tmux)
#
#check_installed() {
#  for i in ${@}
#  do
#    if (( !$+commands[${${i}}] )); then
#      . ${script_dir}/${${i}}
#    fi
#  done
#}
#
#check_installed ${targets}
