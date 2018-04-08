#!/bin/bash
#
# Download dependeties for tests and run full test suit
#
SCRIPT_FOLDER=$(dirname "$(readlink -f "$0")")

cd "${SCRIPT_FOLDER}/.."

if [ ! -d "vader.vim" ]; then
  git clone https://github.com/junegunn/vader.vim.git
fi

vim -Nu test/init.vim -c 'Vader! test/**/*' > /dev/null

