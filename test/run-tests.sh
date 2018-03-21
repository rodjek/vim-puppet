#!/bin/bash
#
# Download dependencies for tests and run full test suit
# Can use TESTVIM env variable to choose between vim and nvim (neovim)
#
set -x
SCRIPT_FOLDER=$(dirname "$(readlink -f "$0")")

# TESTVIM env variable has precedence over installed programs
# next in row is neovim and last one is vim
if [ "$TESTVIM" == "vim" ]; then
  RUNVIM=vim
elif [ "$TESTVIM" == "nvim" ] || [ -x "$(command -v nvim)" ]; then
  RUNVIM=nvim
  export VADER_OUTPUT_FILE=$(mktemp)
  trap "rm -f ${VADER_OUTPUT_FILE}" EXIT INT QUIT TERM
elif [ -x "$(command -v vim)" ]; then
  RUNVIM=vim
else
  echo 'Error: vim is not installed.' >&2
  exit 1
fi

cd "${SCRIPT_FOLDER}/.."

if [ ! -d "vader.vim" ]; then
  git clone https://github.com/junegunn/vader.vim.git
fi
if [ ! -d "tabular" ]; then
  git clone https://github.com/godlygeek/tabular.git
fi


"${RUNVIM}" -u test/init.vim -c 'Vader! test/**/*.vader' > /dev/null
vader_exit=$?
[ -n "${VADER_OUTPUT_FILE}" ] && cat "${VADER_OUTPUT_FILE}"
exit $vader_exit

