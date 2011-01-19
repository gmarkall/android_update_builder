#!/bin/bash

update_file=META-INF/com/google/android/update-script

rm -f $update_file

(cat << EOF) >> $update_file
show_progress 0.1 0

format SYSTEM:
copy_dir PACKAGE:system SYSTEM:

EOF

for pair in `ls -l system/bin | grep -e "->" | awk '{print $9 "-" $11}'`; do
  link=`echo $pair | awk -F'-' '{print \$1}'`
  target=`echo $pair | awk -F'-' '{print \$2}'`
  echo symlink $target SYSTEM:bin/$link >> $update_file
  rm system/bin/$link
done

(cat << EOF) >> $update_file

set_perm_recursive 0 0 0755 0644 SYSTEM:
set_perm_recursive 0 2000 0755 0755 SYSTEM:bin
set_perm 0 3003 02755 SYSTEM:bin/netcfg
set_perm 0 3004 02755 SYSTEM:bin/ping
set_perm_recursive 0 2000 0755 0755 SYSTEM:etc/ppp
set_perm 1002 1002 0440 SYSTEM:etc/dbus.conf
set_perm 1014 2000 0550 SYSTEM:etc/dhcpcd/dhcpcd-run-hooks
set_perm 0 2000 0550 SYSTEM:etc/init.goldfish.sh
set_perm 0 0 04755 SYSTEM:bin/su


show_progress 0.2 0
format BOOT:
write_raw_image PACKAGE:boot.img BOOT:

format CACHE:
show_progress 0.2 10
EOF
