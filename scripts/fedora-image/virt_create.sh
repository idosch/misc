#!/bin/bash
# Create a Fedora virtual machine and a corresponding qemu wrapper

set -e
source env.sh

mkdir -p $IMAGE_DIR
mkdir -p $SSH_DIR

virt-builder fedora-27 \
	-o $IMAGE.img \
	--size 10G \
	--root-password password:123456 \
	--hostname april \
	--timezone Asia/Jerusalem

cat <<'EOF' > qemu_run.sh
#!/bin/bash

qemu-system-x86_64 \
	-kernel arch/x86_64/boot/bzImage \
	-enable-kvm \
	-smp 2 \
	-m 2048 \
	-drive file=MYIMAGE.img,if=virtio,format=raw \
	-append 'root=/dev/vda4 console=hvc0 audit=0' \
	-display none \
	-net nic,model=virtio \
	-net user,hostfwd=tcp:127.0.0.1:4444-:22 \
	-device virtio-serial \
	-chardev stdio,id=virtiocon0 \
	-device virtconsole,chardev=virtiocon0 \
	-fsdev local,id=fs1,path=MYSHARE,security_model=none,readonly \
	-device virtio-9p-pci,fsdev=fs1,mount_tag=host-code
EOF

sed -i s#MYIMAGE#$IMAGE# qemu_run.sh
sed -i s#MYSHARE#$SHARE_DIR# qemu_run.sh

chmod +x qemu_run.sh
