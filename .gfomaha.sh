#!/bin/bash

if test "$#" = 0; then
	echo "$0 <img> <stage3> <stage4/>" >&2
	exit 1
fi
gf=$(which guestfish)

(cd "$3"; tar c --owner=0 --group=0 .) | "$gf" \
	-N "$1"=disk:2G -- \
	part-init /dev/sda gpt : \
	part-add /dev/sda p 34 16384 : \
	part-add /dev/sda p 16385 32768   : \
	part-add /dev/sda p 32769 65536 : \
	part-add /dev/sda p 65537 4194270 : \
	part-set-gpt-type /dev/sda 1 FE3A2A5D-4F32-41A7-B725-ACCC3285A309 : \
	part-set-gpt-type /dev/sda 2 FE3A2A5D-4F32-41A7-B725-ACCC3285A309 : \
	mkfs ext2 /dev/sda3 : \
	mkfs ext4 /dev/sda4 : \
	set-label /dev/sda3 BOOT : \
	set-label /dev/sda4 ROOT : \
	mount /dev/sda4 / : \
	tar-in "$2" / compress:bzip2 : \
	mount /dev/sda3 /boot : \
	-tar-in - / : \
	copy-file-to-device /boot/omaha.kpart /dev/sda1 : \
	copy-file-to-device /boot/omaha.kpart /dev/sda2 : \
	umount /boot : umount / : \
	resize2fs-M /dev/sda4

cgpt add -i 1 -T 15 -P 15 -S 1 $1
cgpt add -i 2 -T 8  -P 8  -S 1 $1
cgpt repair $1
