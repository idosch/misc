#!/bin/bash

config_enable()
{
	scripts/config -e $1
}

config_disable()
{
	scripts/config -d $1
}

config_module()
{
	scripts/config -m $1
}

config_set_str()
{
	local opt=$1; shift
	local str=$1; shift

	scripts/config --set-str $opt $str
}

config_set_val()
{
	local opt=$1; shift
	local val=$1; shift

	scripts/config --set-val $opt $val
}

config()
{
	# Start with a relatively minimal config
	make defconfig &> /dev/null

	# General setup
	config_enable CONFIG_LOCALVERSION_AUTO
	config_set_str CONFIG_LOCALVERSION "-custom"
	config_enable CONFIG_BPF_SYSCALL
	config_enable CONFIG_CGROUPS
	config_enable CONFIG_CGROUP_BPF
	config_enable CONFIG_IKCONFIG
	config_enable CONFIG_IKCONFIG_PROC
	config_enable CONFIG_HIGH_RES_TIMERS
	config_enable CONFIG_MODULES
	config_disable CONFIG_SYSVIPC
	config_disable CONFIG_POSIX_MQUEUE
	config_disable CONFIG_CROSS_MEMORY_ATTACH
	config_disable CONFIG_USELIB
	config_disable CONFIG_AUDIT
	config_disable CONFIG_CGROUP_SCHED
	config_disable CONFIG_CGROUP_FREEZER
	config_disable CONFIG_CPUSETS
	config_disable CONFIG_CGROUP_CPUACCT

	# Processor type and features
	config_disable CONFIG_X86_EXTENDED_PLATFORM
	config_disable CONFIG_IOSF_MBI
	config_disable CONFIG_CALGARY_IOMMU

	# Power management
	config_disable CONFIG_SUSPEND
	config_disable CONFIG_HIBERNATION
	config_disable CONFIG_PM
	config_disable CONFIG_ACPI_AC
	config_disable CONFIG_ACPI_BATTERY
	config_disable CONFIG_ACPI_BUTTON
	config_disable CONFIG_ACPI_FAN
	config_disable CONFIG_ACPI_DOCK

	# Block layer
	config_disable CONFIG_BLK_DEV_BSG
	config_disable CONFIG_BLK_DEBUG_FS
	config_disable CONFIG_PARTITION_ADVANCED

	# Networking support
	config_disable CONFIG_HAMRADIO
	config_disable CONFIG_RFKILL
	config_enable CONFIG_NET
	config_enable CONFIG_PACKET
	config_enable CONFIG_PACKET_DIAG
	config_enable CONFIG_UNIX
	config_enable CONFIG_INET
	config_disable CONFIG_IP_PNP
	config_enable CONFIG_IP_MULTICAST
	config_enable CONFIG_IP_ADVANCED_ROUTER
	config_enable CONFIG_IP_MULTIPLE_TABLES
	config_enable CONFIG_IP_ROUTE_MULTIPATH
	config_module CONFIG_NET_IPIP
	config_module CONFIG_NET_IPGRE_DEMUX
	config_module CONFIG_NET_IPGRE
	config_enable CONFIG_IP_MROUTE
	config_enable CONFIG_IP_MROUTE_MULTIPLE_TABLES
	config_enable CONFIG_IP_PIMSM_V1
	config_enable CONFIG_IP_PIMSM_V2
	config_disable CONFIG_XFRM_USER
	config_disable CONFIG_INET_XFRM_MODE_TRANSPORT
	config_disable CONFIG_INET_XFRM_MODE_TUNNEL
	config_disable CONFIG_INET_XFRM_MODE_BEET
	config_enable CONFIG_INET_DIAG
	config_module CONFIG_IPV6
	config_disable CONFIG_INET6_XFRM_MODE_TRANSPORT
	config_disable CONFIG_INET6_XFRM_MODE_TUNNEL
	config_disable CONFIG_INET6_XFRM_MODE_BEET
	config_disable CONFIG_IPV6_SIT
	config_enable CONFIG_IPV6_MULTIPLE_TABLES
	config_enable CONFIG_IPV6_MROUTE
	config_enable CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
	config_enable CONFIG_IPV6_PIMSM_V2
	config_module CONFIG_IPV6_GRE
	config_disable CONFIG_INET6_AH
	config_disable CONFIG_INET6_ESP
	config_disable CONFIG_NETWORK_SECMARK
	config_disable CONFIG_NETLABEL
	config_disable CONFIG_NETFILTER
	config_module CONFIG_BRIDGE
	config_enable CONFIG_BRIDGE_IGMP_SNOOPING
	config_module CONFIG_VLAN_8021Q
	config_enable CONFIG_BRIDGE_VLAN_FILTERING
	config_enable CONFIG_NET_SCHED
	config_module CONFIG_NET_SCH_PRIO
	config_module CONFIG_NET_SCH_RED
	config_enable CONFIG_NET_SCH_DEFAULT
	config_disable CONFIG_NET_EMATCH
	config_module CONFIG_NET_CLS_FLOWER
	config_module CONFIG_NET_CLS_MATCHALL
	config_module CONFIG_NET_CLS_BPF
	config_enable CONFIG_NET_CLS_ACT
	config_module CONFIG_NET_ACT_GACT
	config_module CONFIG_NET_ACT_MIRRED
	config_module CONFIG_NET_ACT_SAMPLE
	config_module CONFIG_NET_ACT_VLAN
	config_module CONFIG_NET_ACT_BPF
	config_module CONFIG_NET_SCH_INGRESS
	config_enable CONFIG_DCB
	config_module CONFIG_OPENVSWITCH
	config_disable CONFIG_OPENVSWITCH_GRE
	config_disable CONFIG_OPENVSWITCH_VXLAN
	config_module CONFIG_NETLINK_DIAG
	config_enable CONFIG_NET_SWITCHDEV
	config_enable CONFIG_NET_L3_MASTER_DEV
	config_module CONFIG_NET_PKTGEN
	config_disable CONFIG_WIRELESS
	config_enable CONFIG_NET_DEVLINK
	config_module CONFIG_NET_9P
	config_enable CONFIG_NET_NS
	config_enable CONFIG_BPF_JIT

	# Device drivers
	config_disable CONFIG_PCCARD
	config_disable CONFIG_CONNECTOR
	config_disable CONFIG_MACINTOSH_DRIVERS
	config_disable CONFIG_FDDI
	config_disable USB_NET_DRIVERS
	config_enable CONFIG_PCI
	config_enable CONFIG_PCI_MSI
	config_enable CONFIG_DEVTMPFS
	config_enable CONFIG_DEVTMPFS_MOUNT
	config_module CONFIG_ATA
	config_enable CONFIG_NETDEVICES
	config_enable CONFIG_NET_CORE
	config_module CONFIG_BONDING
	config_module CONFIG_DUMMY
	config_module CONFIG_NET_TEAM
	config_module CONFIG_NET_TEAM_MODE_LOADBALANCE
	config_module CONFIG_MACVLAN
	config_module CONFIG_VXLAN
	config_module CONFIG_TUN
	config_module CONFIG_VETH
	config_module CONFIG_NLMON
	config_module CONFIG_NET_VRF
	config_module CONFIG_NETDEVSIM
	config_disable CONFIG_NETCONSOLE
	config_enable CONFIG_ETHERNET
	config_module CONFIG_E1000
	config_module CONFIG_E1000E
	config_module CONFIG_IGB
	config_disable CONFIG_E100
	config_disable CONFIG_NET_VENDOR_BROADCOM
	config_disable CONFIG_NET_VENDOR_DEC
	config_disable CONFIG_NET_VENDOR_MARVELL
	config_disable CONFIG_NET_VENDOR_REALTEK
	config_disable CONFIG_PHYLIB
	config_disable CONFIG_MDIO_DEVICE
	config_module CONFIG_MLXSW_CORE
	config_disable CONFIG_MLXSW_SWITCHIB
	config_disable CONFIG_MLXSW_SWITCHX2
	config_disable CONFIG_WLAN
	config_module CONFIG_VIRTIO_PCI
	config_module CONFIG_VIRTIO_BALLOON
	config_module CONFIG_VIRTIO_INPUT
	config_module CONFIG_I2C_MLXCPLD
	config_module CONFIG_I2C_MUX
	config_module CONFIG_I2C_MUX_MLXCPLD
	config_enable CONFIG_NEW_LEDS
	config_module CONFIG_LEDS_CLASS
	config_module CONFIG_LEDS_MLXCPLD
	config_module CONFIG_LEDS_MLXREG
	config_enable CONFIG_MELLANOX_PLATFORM
	config_enable CONFIG_REGMAP
	config_module CONFIG_MLXREG_HOTPLUG
	config_module CONFIG_MLXREG_IO
	config_module CONFIG_MLX_PLATFORM
	config_module CONFIG_SENSORS_MLXREG_FAN
	config_disable CONFIG_UEVENT_HELPER
	config_disable CONFIG_SOUND
	config_disable CONFIG_AGP
	config_disable CONFIG_DRM
	config_disable CONFIG_BACKLIGHT_LCD_SUPPORT
	config_disable CONFIG_LOGO
	config_disable CONFIG_PTP_1588_CLOCK
	config_disable CONFIG_BLK_DEV_MD
	config_disable CONFIG_PPS
	config_disable CONFIG_INPUT_MOUSE
	config_disable CONFIG_INPUT_JOYSTICK
	config_disable CONFIG_INPUT_TABLET
	config_disable CONFIG_INPUT_TOUCHSCREEN
	config_disable CONFIG_INPUT_MISC
	config_disable CONFIG_SERIAL_NONSTANDARD
	config_module CONFIG_NET_DROP_MONITOR

	# File systems
	config_module CONFIG_XFS_FS
	config_module CONFIG_EXT4_FS
	config_module CONFIG_9P_FS
	config_module CONFIG_NFS_FS
	config_module CONFIG_NFS_V4
	config_enable CONFIG_NFS_V4_1
	config_enable CONFIG_NFS_V4_2
	config_module CONFIG_AUTOFS_FS
	config_enable CONFIG_TMPFS
	config_enable CONFIG_DEBUG_FS
	config_disable CONFIG_ISO9660_FS
	config_disable CONFIG_MSDOS_FS
	config_disable CONFIG_VFAT_FS
	config_disable CONFIG_MISC_FILESYSTEMS

	# Security
	config_disable SECURITY_SELINUX
	config_disable CONFIG_SECURITY
	config_disable CONFIG_PAGE_TABLE_ISOLATION

	# Cryptographic API
	config_disable CONFIG_CRYPTO_RSA
	config_disable CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
	config_disable CONFIG_CRYPTO_AUTHENC
	config_disable CONFIG_CRYPTO_CCM
	config_disable CONFIG_CRYPTO_GCM
	config_disable CONFIG_CRYPTO_ECHAINIV
	config_disable CONFIG_CRYPTO_CBC
	config_disable CONFIG_CRYPTO_CTR
	config_disable CONFIG_CRYPTO_SEQIV
	config_disable CONFIG_CRYPTO_NULL
	config_disable CONFIG_CRYPTO_CMAC
	config_disable CONFIG_CRYPTO_GHASH
	config_disable CONFIG_CRYPTO_SHA1
	config_disable CONFIG_CRYPTO_ARC4
	config_disable CONFIG_CRYPTO_DES
	config_disable CONFIG_CRYPTO_DRBG_MENU
	config_disable CONFIG_CRYPTO_JITTERENTROPY
	config_disable CONFIG_CRYPTO_HW
	config_disable CONFIG_ASYMMETRIC_KEY_TYPE
	config_disable CONFIG_CRYPTO_SHA256
	config_disable CONFIG_CRYPTO_HMAC
	config_disable CONFIG_CRYPTO_GF128MUL
	config_disable CONFIG_CRYPTO_MANAGER

	# Virtualization
	config_module CONFIG_KVM
	config_module CONFIG_KVM_INTEL
	config_module CONFIG_VIRTIO
	config_module CONFIG_VIRTIO_PCI
	config_module CONFIG_VIRTIO_BLK
	config_module CONFIG_NET_9P
	config_module CONFIG_NET_9P_VIRTIO
	config_module CONFIG_VIRTIO_NET
	config_module CONFIG_VIRTIO_CONSOLE
	config_module CONFIG_SCSI_VIRTIO
}

debug_enable()
{
	# Debug options
	## General debug options
	config_enable CONFIG_PREEMPT
	config_enable CONFIG_DEBUG_PREEMPT
	config_enable CONFIG_DEBUG_INFO
	config_enable CONFIG_UNWINDER_ORC
	config_enable CONFIG_DYNAMIC_DEBUG
	config_enable CONFIG_DEBUG_NOTIFIERS
	## Lock debugging
	config_enable CONFIG_LOCKDEP
	config_enable CONFIG_PROVE_LOCKING
	config_enable CONFIG_DEBUG_ATOMIC_SLEEP
	config_enable CONFIG_PROVE_RCU
	config_enable CONFIG_DEBUG_MUTEXES
	config_enable CONFIG_DEBUG_SPINLOCK
	config_enable CONFIG_LOCK_STAT
	## Memory debugging
	config_enable CONFIG_DEBUG_VM
	config_enable CONFIG_FORTIFY_SOURCE
	config_enable CONFIG_KASAN
	config_enable CONFIG_KASAN_EXTRA
	config_enable CONFIG_KASAN_INLINE
	## Reference counting debugging
	config_enable CONFIG_REFCOUNT_FULL
	## Lockups debugging
	config_enable CONFIG_LOCKUP_DETECTOR
	config_enable CONFIG_SOFTLOCKUP_DETECTOR
	config_enable CONFIG_HARDLOCKUP_DETECTOR
	config_enable CONFIG_DETECT_HUNG_TASK
	config_enable CONFIG_WQ_WATCHDOG
	config_enable CONFIG_DETECT_HUNG_TASK
	config_set_val CONFIG_DEFAULT_HUNG_TASK_TIMEOUT 120
	## Undefined behavior debugging
	config_enable CONFIG_UBSAN
	config_enable CONFIG_UBSAN_SANITIZE_ALL
	config_disable CONFIG_UBSAN_ALIGNMENT
	config_disable CONFIG_UBSAN_NULL
	## Tracing
	config_enable CONFIG_FUNCTION_TRACER
	config_enable CONFIG_FUNCTION_GRAPH_TRACER
	config_enable CONFIG_STACK_TRACER
	config_enable CONFIG_DYNAMIC_FTRACE
	config_enable CONFIG_FTRACE_SYSCALLS
	## Code coverage
	config_enable CONFIG_KCOV
}

perf_enable()
{
	# Enable options for perf utility. From:
	# http://www.brendangregg.com/perf.html#Building
	config_enable CONFIG_PERF_EVENTS
	config_enable CONFIG_UNWINDER_FRAME_POINTER
	config_enable CONFIG_FRAME_POINTER
	config_enable CONFIG_KALLSYMS
	config_enable CONFIG_TRACEPOINTS
	config_enable CONFIG_FTRACE
	config_enable CONFIG_KPROBES
	config_enable CONFIG_KPROBE_EVENTS
	config_enable CONFIG_UPROBES
	config_enable CONFIG_UPROBE_EVENTS
	config_enable CONFIG_DEBUG_INFO
	config_enable CONFIG_LOCKDEP
	config_enable CONFIG_LOCK_STAT
}

more_debug_enable()
{
	debug_enable

	# More debug options
	## Memory debugging
	config_enable CONFIG_SLUB_DEBUG
	config_enable CONFIG_SLUB_DEBUG_ON
	config_enable CONFIG_DEBUG_PAGEALLOC
	config_enable CONFIG_DEBUG_KMEMLEAK
	config_disable CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
	config_set_val CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE 8192
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
	## Lock debugging
	config_enable CONFIG_DEBUG_LOCK_ALLOC
	config_enable CONFIG_PROVE_LOCKING
	config_enable CONFIG_LOCK_STAT
	config_enable CONFIG_DEBUG_OBJECTS_RCU_HEAD
	config_enable CONFIG_SPARSE_RCU_POINTER
}

usage()
{
	cat <<EOF
usage: ${0##*/} OPTS
        -c          Only create config file. Do not compile
	-m          Use modules when possible
	-d          Enable debug options (slow)
	-p          Enable options for perf utility
	-D          Enable even more debug options (very slow)
EOF
}

while getopts ":cmdpDh" opt; do
	case ${opt} in
		c) CONFIG_ONLY=yes;;
		m) MODULES=yes;;
		d) DEBUG=yes;;
		p) PERF=yes;;
		D) MORE_DEBUG=yes;;
		h) usage; exit 0;;
		\?) usage; exit 1;;
	esac
done

config

if [[ "$DEBUG" = "yes" ]]; then
	debug_enable
fi

if [[ "$PERF" = "yes" ]]; then
	perf_enable
fi

if [[ "$MORE_DEBUG" = "yes" ]]; then
	more_debug_enable
fi

if [[ "$MODULES" = "" ]]; then
	config_disable CONFIG_MODULES
fi

# Set new symbols to their default
make olddefconfig &> /dev/null

if [[ "$CONFIG_ONLY" = "yes" ]]; then
	exit 0
fi

make -j`nproc`
