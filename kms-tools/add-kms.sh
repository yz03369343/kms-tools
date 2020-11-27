#!/bin/bash
if  [ ! -f tools ] && [ ! -d agent ] && [ ! -d oem-file ];then
	echo -e "\033[31mDirectory is ERROR!!! \033[0m"
	exit 10
fi
KMS_ACTIVE=Y

. ./tools

find_iso_dir

chose_arch

chose_oem_file

case $OEM_FILE in 
	01_installer*.tgz) tar_oem_file
	   change_kms "Vlc1cGIyNTBaV05v" "10.10.58.44" "8600"
	   ;;
	02_checkmode-auto*.tgz|03_checkmode-notauto*.tgz) tar_oem_file
	   open_check_mode
           change_kms "Vlc1cGIyNTBaV05v" "10.10.58.44" "8600" 
	   ;;
	thtf*.tgz|lenovo*.tgz|100trust-kms*.tgz|baode*.tgz|insur*.tgz) tar_oem_file
	   open_check_mode
	   ;;
	100trust-nokms*.tgz) KMS_ACTIVE=N
	   tar_oem_file
	   ;;
	*) echo -e "\033[31mInput is ERROR!!! \033[0m"
	   exit 11
	   ;;
esac
