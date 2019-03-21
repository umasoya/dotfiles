# {{{ available_filter(): return available filter
available_filter() {
  local x candidates
  candidates="$1:"
  while [ -n "$candidates" ]
  do
    x=${candidates%%:*}
    candidates=${candidates#*:}
    if type "$x" > /dev/null 2>&1; then
      echo "$x"
      return 0
    else
      continue
    fi
  done
  return 1
}
# }}}

# {{{ repo(): ghq + filter
repo() {
  local filter=$(available_filter ${FILTER})
  local to=$(ghq root)/$(ghq list | ${filter})
  \cd ${to}
}
# }}}
