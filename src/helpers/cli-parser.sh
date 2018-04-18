#! /bin/bash

# copied from https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options/7680682#7680682

function parseCliParams() {
  optspec=":hv-:"
  while getopts "$optspec" optchar; do
    case "${optchar}" in
      -)
        case "${OPTARG}" in
          provision)
            provision="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
            ;;
          provision=*)
            provision=${OPTARG#*=}
            ;;
          *)
            if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
              echo "Unknown option --${OPTARG}" >&2
            fi
            ;;
        esac;;
      h)
        echo "usage: $0 [-v] [--provision[=]<value>]" >&2
        exit 2
        ;;
      v)
        echo "Parsing option: '-${optchar}'" >&2
        ;;
      *)
        if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
          echo "Non-option argument: '-${OPTARG}'" >&2
        fi
        ;;
    esac
  done
}
