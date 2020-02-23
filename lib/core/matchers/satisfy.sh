#shellcheck shell=sh disable=SC2016

shellspec_syntax 'shellspec_matcher_satisfy'

SHELLSPEC_SATISFY_STDOUT_FILE="$SHELLSPEC_TMPBASE/$$.satisfy.stdout"
SHELLSPEC_SATISFY_STDERR_FILE="$SHELLSPEC_TMPBASE/$$.satisfy.stderr"

shellspec_matcher_satisfy() {
  shellspec_matcher__match() {
    if ! shellspec_is_function "${1:-}"; then
      shellspec_output SYNTAX_ERROR "'$1' is not function name"
      return 0
    fi

    # shellcheck disable=SC2034
    IFS=" $IFS" && SHELLSPEC_EXPECT="$*" && IFS=${IFS#?}
    ( if shellspec_is_identifier "$1"; then
        if [ "${SHELLSPEC_SUBJECT+x}" ]; then
          eval "$1=\$SHELLSPEC_SUBJECT"
        else
          unset "$1" ||:
        fi
      fi
      "$@"
    ) >"$SHELLSPEC_SATISFY_STDOUT_FILE" 2>"$SHELLSPEC_SATISFY_STDERR_FILE" &&:

    set -- "$?"
    if [ -s "$SHELLSPEC_SATISFY_STDOUT_FILE" ]; then
      shellspec_output SATISFY_WARN "$1" "$SHELLSPEC_SATISFY_STDOUT_FILE"
    fi
    if [ -s "$SHELLSPEC_SATISFY_STDERR_FILE" ]; then
      shellspec_output SATISFY_ERROR "$1" "$SHELLSPEC_SATISFY_STDERR_FILE"
    fi
    return "$1"
  }

  shellspec_syntax_failure_message + 'expected $1 satisfies $2'
  shellspec_syntax_failure_message - 'expected $1 does not satisfy $2'

  shellspec_syntax_param count [ $# -gt 0 ] || return 0
  shellspec_matcher_do_match "$@"
}
