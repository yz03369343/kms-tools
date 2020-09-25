#!/bin/bash
if  [ ! -f ./tools ] ;then
	echo -e "\033[31mDirectory is ERROR!!! \033[0m"
	exit 10
fi
SCRIPT_DIR=`pwd`
DATE=`date "+%Y%m%d%H%M%S"`
XORRISO_STAT=`dpkg -l | grep xorriso | awk '{print $2}'`
ISOLINUX_STAT=`dpkg -l | grep isolinux | awk '{print $2}'`
. ./tools


if [ -z $XORRISO_STAT ] || [ -z $ISOLINUX_STAT ]; then
	sudo apt update && sudo apt install isolinux xorriso -y
	if [ $? ! = 0 ]; then
		echo -e "\033[31mInstall isolinux or xorriso ERROR!!! \033[0m"	
		exit 11
	fi
fi

find_iso_dir
chose_arch
mkdir -p iso 2>/dev/null
case $ISO_ARCH in
	1) cd $TARGET_DIR
        xorriso -as mkisofs -o $SCRIPT_DIR/iso/uos-amd64-$DATE.iso -no-pad -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/efi.img -no-emul-boot -append_partition 2 0x01 boot/efi.img -isohybrid-gpt-basdat -isohybrid-apm-hfsplus -appid "Uos LiveCD" -publisher "Uos <http://www.deepin.com>" -V "uos20" .
	;;
	2) cd $TARGET_DIR
	xorriso -as mkisofs -r -J -c boot.cat -boot-load-size 4 -boot-info-table -eltorito-alt-boot --efi-boot boot/grub/efi.img -no-emul-boot -V "uos 20" -file_name_limit 250 -o $SCRIPT_DIR/iso/uos-arm64-$DATE.iso .
	;;
	3) cd $TARGET_DIR 
	xorriso -as mkisofs -V "UOS 20" -R -r -J -joliet-long -l -cache-inodes -o $SCRIPT_DIR/iso/uos-mips64el-$DATE.iso .
	;;
	*) echo -e "\033[31mInput ERROR!!! \033[0m"
	;;
esac
