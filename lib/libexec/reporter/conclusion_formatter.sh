#shellcheck shell=sh

: "${example_index:-} ${detail_index:-}"
: "${field_specfile:-} ${field_lineno:-} ${field_color:-} ${field_type:-}"
: "${field_tag:-} ${field_note:-} ${field_evaluation:-}"
: "${field_message:-} ${field_failure_message:-} ${field_pending:-}"

conclusion_evaluation=''
conclusion_last_example_index='' conclusion_detail_index=''
create_buffers conclusion

conclusion_each() {
  _label='' _indent='' _message='' _text=''

  case $field_type in
    example) conclusion_evaluation='' ;;
    statement)
      case $field_tag in
        evaluation) conclusion_evaluation=$field_evaluation && return 0 ;;
        good) [ "$field_pending" ] || return 0
      esac
      [ "$example_index" ] || return 0

      conclusion '|=' "Examples:${LF}"
      _label="  $example_index) "
      padding _indent ' ' ${#_label}
      if [ "$example_index" != "$conclusion_last_example_index" ]; then
        conclusion '+=' "${WHITE}${_label}$(field_description)${RESET}${LF}"
        conclusion_last_example_index=$example_index
        conclusion_detail_index=0
      fi
      inc conclusion_detail_index

      if [ "$conclusion_evaluation" ]; then
        conclusion '+=' "${BOLD}${CYAN}${_indent}${conclusion_evaluation}"
        conclusion '+=' "${RESET}${LF}${LF}"
        conclusion_evaluation=''
      fi

      _label="${_indent}${example_index}.${conclusion_detail_index}) "
      padding _indent ' ' ${#_label}

      _message="${field_note:+[}$field_note${field_note:+] }$field_message"
      conclusion '+=' "${_label}${field_color}${_message}${RESET}${LF}${LF}"

      case $field_tag in (warn|bad)
        _message=$field_failure_message _text=''
        while [ "$_text" != "$_message" ]; do
          _text=${_message%%${LF}*}
          _message=${_message#*${LF}}
          conclusion '+=' "  ${_indent}${field_color}${_text}${RESET}${LF}"
        done
      esac

      conclusion '+=' "${_indent}${CYAN}#" \
        "${field_specfile}:${field_lineno}${RESET}${LF}${LF}"
  esac
}

conclusion_end() {
  conclusion '<|>'
}

conclusion_output() {
  case $1 in (end)
    conclusion '>>>'
  esac
}
