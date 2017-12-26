#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.5.0
# ARG_OPTIONAL_BOOLEAN([debug],[d],[Enable useful debug options])
# ARG_OPTIONAL_BOOLEAN([heavy-debug],[D],[Enable a lot of debug options. Results in a very slow kernel.])
# ARG_POSITIONAL_SINGLE([branch],[Branch to deploy],)
# ARG_HELP([Small utility script to easily deploy kernels for testing])
# ARGBASH_GO

# [ <-- needed because of Argbash

echo "debug is $_arg_debug"
echo "heavy-debug is $_arg_heavy_debug"
echo "Value of branch: $_arg_branch"

# ] <-- needed because of Argbash
