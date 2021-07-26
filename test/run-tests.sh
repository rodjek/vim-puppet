#!/bin/bash
#
# Download dependencies for tests and run full test suit
# Can use TESTVIM env variable to choose between vim and nvim (neovim)
# Optional first script argument can be path to vader file (run only one suite)
#
set -x
TEST_FILE=$1
SCRIPT_FOLDER=$(dirname "$(readlink -f "$0")")

# TESTVIM env variable has precedence over installed programs
# next in row is neovim and last one is vim
if [ "$TESTVIM" == "vim" ]; then
  RUNVIM=vim
elif [ "$TESTVIM" == "nvim" ] || [ -x "$(command -v nvim)" ]; then
  RUNVIM=nvim
  VADER_OUTPUT_FILE=$(mktemp)
  export VADER_OUTPUT_FILE
  trap 'rm -f ${VADER_OUTPUT_FILE}' EXIT INT QUIT TERM
elif [ -x "$(command -v vim)" ]; then
  RUNVIM=vim
else
  echo 'Error: vim is not installed.' >&2
  exit 1
fi

cd "${SCRIPT_FOLDER}/.." || exit

if [ ! -d "vader.vim" ]; then
  git clone https://github.com/junegunn/vader.vim.git
fi

if [ -z "$TEST_FILE" ]; then
  TEST_SUITE='test/**/*.vader'
else
  TEST_SUITE=$TEST_FILE
fi

"${RUNVIM}" -u test/init.vim -c "Vader! ${TEST_SUITE}" > /dev/null
vader_exit=$?
[ -n "${VADER_OUTPUT_FILE}" ] && cat "${VADER_OUTPUT_FILE}"
exit $vader_exit

