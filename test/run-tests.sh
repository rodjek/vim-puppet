#!/bin/bash
#
# Download dependencies for tests and run full test suit
#
SCRIPT_FOLDER=$(dirname "$(readlink -f "$0")")

if [ -x "$(command -v vim)" ]; then
  VIM=vim
elif [ -x "$(command -v nvim)" ]; then
  VIM=nvim
  export VADER_OUTPUT_FILE=$(mktemp)
  trap "rm -f ${VADER_OUTPUT_FILE}" EXIT INT QUIT TERM
else
  echo 'Error: vim is not installed.' >&2
  exit 1
fi

cd "${SCRIPT_FOLDER}/.."

if [ ! -d "vader.vim" ]; then
  git clone https://github.com/junegunn/vader.vim.git
fi

"${VIM}" -u test/init.vim -c 'Vader! test/**/*.vader' > /dev/null
vader_exit=$?
[ -n "${VADER_OUTPUT_FILE}" ] && cat "${VADER_OUTPUT_FILE}"
exit $vader_exit
