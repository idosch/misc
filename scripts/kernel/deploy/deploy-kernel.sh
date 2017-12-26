#!/bin/bash

die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}

begins_with_short_option()
{
	local first_option all_short_options
	all_short_options='dDh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}



# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_debug=off
_arg_heavy_debug=off

print_help ()
{
	printf "%s\n" "Small utility script to easily deploy kernels for testing"
	printf 'Usage: %s [-d|--(no-)debug] [-D|--(no-)heavy-debug] [-h|--help] <branch>\n' "$0"
	printf "\t%s\n" "<branch>: Branch to deploy"
	printf "\t%s\n" "-d,--debug,--no-debug: Enable useful debug options (off by default)"
	printf "\t%s\n" "-D,--heavy-debug,--no-heavy-debug: Enable a lot of debug options. Results in a very slow kernel. (off by default)"
	printf "\t%s\n" "-h,--help: Prints help"
}

parse_commandline ()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-d|--no-debug|--debug)
				_arg_debug="on"
				test "${1:0:5}" = "--no-" && _arg_debug="off"
				;;
			-d*)
				_arg_debug="on"
				_next="${_key##-d}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					begins_with_short_option "$_next" && shift && set -- "-d" "-${_next}" "$@" || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-D|--no-heavy-debug|--heavy-debug)
				_arg_heavy_debug="on"
				test "${1:0:5}" = "--no-" && _arg_heavy_debug="off"
				;;
			-D*)
				_arg_heavy_debug="on"
				_next="${_key##-D}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					begins_with_short_option "$_next" && shift && set -- "-D" "-${_next}" "$@" || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_positionals+=("$1")
				;;
		esac
		shift
	done
}


handle_passed_args_count ()
{
	_required_args_string="'branch'"
	test ${#_positionals[@]} -lt 1 && _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 1 (namely: $_required_args_string), but got only ${#_positionals[@]}." 1
	test ${#_positionals[@]} -gt 1 && _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 1 (namely: $_required_args_string), but got ${#_positionals[@]} (the last one was: '${_positionals[*]: -1}')." 1
}

assign_positional_args ()
{
	_positional_names=('_arg_branch' )

	for (( ii = 0; ii < ${#_positionals[@]}; ii++))
	do
		eval "${_positional_names[ii]}=\${_positionals[ii]}" || die "Error during argument parsing, possibly an Argbash bug." 1
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args

echo "debug is $_arg_debug"
echo "heavy-debug is $_arg_heavy_debug"
echo "Value of branch: $_arg_branch"

if [ ! -f deploy.config ]; then
	echo "Missing deploy.config" >&2
	exit 1
fi

source ./deploy.config

echo "Building kernel on build server: $BUILD_SERVER"
ssh $BUILD_SERVER kernel_dir=$KERNEL_DIR remote=$REMOTE branch=$_arg_branch \
	debug=$_arg_debug heavy_debug=$_arg_heavy_debug 'bash -s' <<'ENDSSH'
cd $kernel_dir
git remote update $remote
git checkout -B $branch $remote/$branch
if [ $debug = "on" ]; then
	echo "debug"
	./compile.sh -d
elif [ $heavy_debug = "on" ]; then
	echo "heavy debug"
	./compile.sh -D
else
	echo "no debug"
	./compile.sh
fi
ENDSSH

echo "Installing kernel on DUT: $DUT"
ssh $DUT kernel_dir=$KERNEL_DIR 'bash -s' <<'ENDSSH'
cd $kernel_dir
sudo make modules_install && sudo make install
sudo grub2-reboot 0 && sudo reboot
ENDSSH
