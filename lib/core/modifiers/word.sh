#shellcheck shell=sh

shellspec_syntax 'shellspec_modifier_word'

shellspec_modifier_word() {
  shellspec_syntax_param count [ $# -ge 1 ] || return 0
  shellspec_syntax_param 1 is number "$1" || return 0

  if [ "${SHELLSPEC_SUBJECT+x}" ]; then
    shellspec_get_nth SHELLSPEC_SUBJECT "$1" "$SHELLSPEC_IFS" "$SHELLSPEC_SUBJECT"
  else
    unset SHELLSPEC_SUBJECT ||:
  fi
  shift

  eval shellspec_syntax_dispatch modifier ${1+'"$@"'}
}
