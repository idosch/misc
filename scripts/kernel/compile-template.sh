#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.5.0
# ARG_OPTIONAL_BOOLEAN([debug],[d], [Enable useful debug options])
# ARG_OPTIONAL_BOOLEAN([heavy-debug],[D], [Enable a lot of debug options. Results in a very slow kernel.])
# ARG_OPTIONAL_BOOLEAN([vm],[v], [Configure kernel for a VM (no modules)])
# ARG_OPTIONAL_BOOLEAN([auto-version],[a], [Configure the kernel with LOCALVERSION_AUTO])
# ARG_HELP([Script to ease kernel configuration and compilation])
# ARGBASH_GO

# [ <-- needed because of Argbash

echo "debug is $_arg_debug"
echo "heavy-debug is $_arg_heavy_debug"
echo "vm is $_arg_vm"
echo "sparse is $_arg_sparse"

# ] <-- needed because of Argbash
