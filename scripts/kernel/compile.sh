#!/bin/bash

config_enable()
{
	scripts/config -e $1
}

config_disable()
{
	scripts/config -d $1
}

config_set_str()
{
	scripts/config --set-str $1 $2
}

config_set_val()
{
	scripts/config --set-val $1 $2
}

config_module()
{
	# virtme --kdir does not work with modules.
	if [ "$_arg_virtme" = "on" ]; then
		scripts/config -e $1
	else
		scripts/config -m $1
	fi
}

prepare_dir()
{
	make clean &> /dev/null
	make defconfig &> /dev/null
	make localmodconfig &> /dev/null
}

kernel_config()
{
	# General
	config_enable CONFIG_LOCALVERSION_AUTO
	config_set_str CONFIG_LOCALVERSION "-custom"
	config_enable CONFIG_BPF_SYSCALL
	config_enable CONFIG_CGROUP_BPF
	# Bus Options
	config_disable CONFIG_PCCARD
	# Networking support
	config_disable CONFIG_XFRM_USER
	config_module CONFIG_NET_IPIP
	config_module CONFIG_NET_IPGRE_DEMUX
	config_module CONFIG_NET_IPGRE
	config_module CONFIG_IPV6_GRE
	config_enable CONFIG_IP_MROUTE_MULTIPLE_TABLES
	config_disable CONFIG_TCP_MD5SIG
	config_disable CONFIG_INET6_AH
	config_disable CONFIG_INET6_ESP
	config_disable CONFIG_INET6_XFRM_MODE_TRANSPORT
	config_disable CONFIG_INET6_XFRM_MODE_TUNNEL
	config_disable CONFIG_INET6_XFRM_MODE_BEET
	config_disable CONFIG_IPV6_SIT
	config_enable CONFIG_IPV6_MULTIPLE_TABLES
	config_disable CONFIG_NETLABEL
	config_disable CONFIG_NETFILTER
	config_module CONFIG_BRIDGE
	config_module CONFIG_VLAN_8021Q
	config_enable CONFIG_BRIDGE_VLAN_FILTERING
	config_enable CONFIG_BRIDGE_IGMP_SNOOPING
	config_module CONFIG_NET_SCH_PRIO
	config_module CONFIG_NET_SCH_RED
	config_module CONFIG_NET_SCH_INGRESS
	config_module CONFIG_NET_CLS_FLOWER
	config_module CONFIG_NET_CLS_MATCHALL
	config_module CONFIG_NET_ACT_GACT
	config_module CONFIG_NET_ACT_MIRRED
	config_module CONFIG_NET_ACT_SAMPLE
	config_module CONFIG_NET_ACT_VLAN
	config_enable CONFIG_DCB
	config_enable CONFIG_NET_SWITCHDEV
	config_enable CONFIG_NET_L3_MASTER_DEV
	config_module CONFIG_NET_PKTGEN
	config_disable CONFIG_HAMRADIO
	config_disable CONFIG_CFG80211
	config_disable CONFIG_RFKILL
	config_enable CONFIG_NET_DEVLINK
	# File systems
	config_module CONFIG_9P_FS
	# Device Drivers
	config_disable CONFIG_MACINTOSH_DRIVERS
	config_module CONFIG_BONDING
	config_module CONFIG_DUMMY
	config_module CONFIG_NET_TEAM
	config_module CONFIG_NET_TEAM_MODE_LOADBALANCE
	config_module CONFIG_TUN
	config_module CONFIG_VETH
	config_module CONFIG_NET_VRF
	config_module CONFIG_IGB
	config_module CONFIG_MLXSW_CORE
	config_enable CONFIG_MLXSW_CORE_HWMON
	config_enable CONFIG_MLXSW_CORE_THERMAL
	config_module CONFIG_MLXSW_PCI
	config_module CONFIG_MLXSW_I2C
	config_disable CONFIG_MLXSW_SWITCHIB
	config_disable CONFIG_MLXSW_SWITCHX2
	config_module CONFIG_MLXSW_SPECTRUM
	config_enable CONFIG_MLXSW_SPECTRUM_DCB
	config_enable CONFIG_MLXSW_MINIMAL
	config_disable CONFIG_FORCEDETH
	config_disable CONFIG_FDDI
	config_disable USB_NET_DRIVERS
	config_disable CONFIG_WLAN
	config_disable CONFIG_AGP
	config_disable CONFIG_DRM
	config_disable CONFIG_BACKLIGHT_LCD_SUPPORT
	config_disable CONFIG_LOGO
	config_disable CONFIG_SOUND
	config_module CONFIG_LEDS_MLXCPLD
	# Virtualization
	config_module CONFIG_KVM
	config_module CONFIG_KVM_INTEL
}

general_debug()
{
	# Mostly based on Documentation/SubmitChecklist.txt
	config_enable CONFIG_PREEMPT
	config_enable CONFIG_DEBUG_PREEMPT
	config_enable CONFIG_SLUB_DEBUG
	config_enable CONFIG_SLUB_DEBUG_ON
	config_enable CONFIG_DEBUG_PAGEALLOC
	config_enable CONFIG_DEBUG_MUTEXES
	config_enable CONFIG_DEBUG_SPINLOCK
	config_enable CONFIG_DEBUG_ATOMIC_SLEEP
	config_enable CONFIG_PROVE_RCU
	config_enable CONFIG_PROVE_RCU_REPEATEDLY
	config_enable CONFIG_KASAN
}

heavy_debug()
{
	# General options
	config_enable CONFIG_CRASH_DUMP
	config_enable CONFIG_DEBUG_INFO
	config_enable CONFIG_PANIC_ON_OOPS
	config_enable CONFIG_DYNAMIC_DEBUG
	config_enable CONFIG_WQ_WATCHDOG
	config_enable CONFIG_DEBUG_NOTIFIERS
	# Memory debugging
	config_enable CONFIG_DEBUG_KMEMLEAK
	config_disable CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
	config_set_val CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE 4096
	config_enable CONFIG_DEBUG_STACKOVERFLOW
	config_enable CONFIG_DEBUG_LIST
	config_enable CONFIG_DEBUG_PER_CPU_MAPS
	config_set_val CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT 1
	config_enable CONFIG_DEBUG_OBJECTS
	config_enable CONFIG_DEBUG_OBJECTS_FREE
	config_enable CONFIG_DEBUG_OBJECTS_TIMERS
	config_enable CONFIG_DEBUG_OBJECTS_WORK
	config_enable CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
	config_enable CONFIG_DMA_API_DEBUG
	# Lock debugging
	config_enable CONFIG_LOCKUP_DETECTOR
	config_enable CONFIG_DETECT_HUNG_TASK
	config_set_val CONFIG_DEFAULT_HUNG_TASK_TIMEOUT 120
	config_enable CONFIG_DEBUG_LOCK_ALLOC
	config_enable CONFIG_PROVE_LOCKING
	config_enable CONFIG_LOCK_STAT
	# RCU debugging (Documentation/RCU/checklist.txt)
	config_enable CONFIG_DEBUG_OBJECTS_RCU_HEAD
	config_enable CONFIG_SPARSE_RCU_POINTER
	# Undefined behavior
	config_enable CONFIG_UBSAN
	config_enable CONFIG_UBSAN_SANITIZE_ALL
	config_disable CONFIG_UBSAN_ALIGNMENT
	config_enable CONFIG_UBSAN_NULL
	# Reference counting
	config_enable CONFIG_REFCOUNT_FULL
}

sparse_allow()
{
	config_disable CONFIG_UNWINDER_ORC
	config_enable CONFIG_UNWINDER_FRAME_POINTER
	config_disable CONFIG_STACK_VALIDATION
}

compile()
{
	make olddefconfig &> /dev/null
	make -j`nproc`
}

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
	all_short_options='dDvsh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}



# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_debug=off
_arg_heavy_debug=off
_arg_virtme=off
_arg_sparse=off

print_help ()
{
	printf "%s\n" "Script to ease kernel configuration and compilation"
	printf 'Usage: %s [-d|--(no-)debug] [-D|--(no-)heavy-debug] [-v|--(no-)virtme] [-s|--(no-)sparse] [-h|--help]\n' "$0"
	printf "\t%s\n" "-d,--debug,--no-debug: Enable useful debug options (off by default)"
	printf "\t%s\n" "-D,--heavy-debug,--no-heavy-debug: Enable a lot of debug options. Results in a very slow kernel. (off by default)"
	printf "\t%s\n" "-v,--virtme,--no-virtme: Configure kernel for virtme (off by default)"
	printf "\t%s\n" "-s,--sparse,--no-sparse: Disable certain configuration options to allow sparse and friends to run (off by default)"
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
			-v|--no-virtme|--virtme)
				_arg_virtme="on"
				test "${1:0:5}" = "--no-" && _arg_virtme="off"
				;;
			-v*)
				_arg_virtme="on"
				_next="${_key##-v}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					begins_with_short_option "$_next" && shift && set -- "-v" "-${_next}" "$@" || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-s|--no-sparse|--sparse)
				_arg_sparse="on"
				test "${1:0:5}" = "--no-" && _arg_sparse="off"
				;;
			-s*)
				_arg_sparse="on"
				_next="${_key##-s}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					begins_with_short_option "$_next" && shift && set -- "-s" "-${_next}" "$@" || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
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
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

prepare_dir
kernel_config

if [ "$_arg_debug" = "on" ]; then
	general_debug
fi

if [ "$_arg_heavy_debug" = "on" ]; then
	general_debug
	heavy_debug
fi

if [ "$_arg_virtme" = "on" ]; then
	virtme-configkernel --update &> /dev/null
fi

if [ "$_arg_sparse" = "on" ]; then
	sparse_allow
fi

compile
