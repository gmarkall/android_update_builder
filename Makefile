all: mkupdate

copyboot:
	cp ${ANDROID_PRODUCT_OUT}/ramdisk.img .
	cp ${ANDROID_KERNEL}/arch/arm/boot/zImage .

copysys:
	cp ${ANDROID_PRODUCT_OUT}/system . -R
	
mkupdatescript: copysys
	./mk_update_script.sh

mkupdate: mkbootimg mkupdatescript
	zip -r unsigned-update system boot.img META-INF
	java -jar ${ANDROID_HOST_OUT}/framework/signapk.jar ${ANDROID_KEY_DIR}/certificate.pem ${ANDROID_KEY_DIR}/key.pk8 unsigned-update.zip grahams-gingerbread-`./calc_buildnum.sh`.zip

mkbootimg: copyboot
	${ANDROID_HOST_OUT}/bin/mkbootimg --kernel zImage --ramdisk ramdisk.img --base 0x20000000 --cmdline 'no_console_suspend=1 msmsdcc_sdioirq=1 wire.search_count=5' -o boot.img

clean: cleansys cleanboot
	rm -f *.zip

cleansys:
	rm -rf system

cleanboot:
	rm -f boot.img ramdisk.img zImage
