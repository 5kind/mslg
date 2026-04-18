mslgservice(){
    $MSLG &
    PID=$!
}
start_time=$(date +%s)
resetprop -w sys.boot_completed 0
sleep 5
sh /vendor/bin/restorecon.sh
sleep 1
resetprop sys.mslg.mounted 0
mslgservice
sleep 1
if [ "$(getprop persist.vendor.unzip.mslgrootfs)" = "enable" ] && [ "$(getprop vendor.mslgrootfs.version)" != "" ]; then
    /vendor/bin/restorecon.sh
    resetprop vendor.mslg.chcon.done 1
fi
if [ "$(getprop vendor.mslg.chcon.done)" = "1" ]; then
     /vendor/bin/tar-rootfs.sh "$(getprop vendor.mslgrootfs.version)"
fi
sleep 1
mv -f /data/media/0/MIUI/mslg/错误日志.log /data/media/0/MIUI/mslg/错误日志.log.bak

if [ ! -f /data/rootfs/mslgusrimg ]; then
    cp /data/media/0/MIUI/mslg/mslgusrimg /data/rootfs && sync
    chmod 0644 /data/rootfs/mslgusrimg
    chown 0:0 /data/rootfs/mslgusrimg
    chcon u:object_r:vendor_file:s0 /data/rootfs/mslgusrimg
    if [ ! -f /data/rootfs/mslgusrimg ]; then
        echo "复制镜像文件失败,请检查镜像文件" >> /data/media/0/MIUI/mslg/错误日志.log
        exit 1
    fi
fi
if [ ! -f /data/rootfs/mslgkingsoftimg ]; then
    tar -xzvf /data/media/0/MIUI/mslg/wps.tar.gz -C /data/rootfs/ && sync
    chmod 0666 /data/rootfs/mslgkingsoftimg
    chmod 0666 /data/rootfs/kingsoft.txt
    chmod 0664 /data/rootfs/kingsoft_md5.txt    
fi
if [ ! -f /data/rootfs/mslgappsimg ]; then
    tar -xzvf /data/media/0/MIUI/mslg/caj.tar.gz -C /data/rootfs/ && sync
    chmod 0664 /data/rootfs/apps_md5.txt
    chmod 0666 /data/rootfs/mslgappsimg
    chmod 0666 /data/rootfs/apps.txt
fi
if [ -f /data/rootfs/mslgusrimg ]; then
   if [ "$(getprop persist.vendor.unzip.mslgrootfs)" = "disable" ] && [ "$(getprop vendor.mslgrootfs.isready)" = "1" ]; then
    test -f /data/media/0/MIUI/mslg/debug && export DEBUG=true || export DEBUG=false
    /vendor/bin/losetup.sh
   fi
else
   echo "挂载回环设备错误" >> /data/media/0/MIUI/mslg/错误日志.log
   exit 1
fi
mv -f /data/media/0/MIUI/mslg/启动日志.log /data/media/0/MIUI/mslg/启动日志.log.bak

if [ "$(getprop vendor.setup.mslgrootfs)" = "1" ] && [ "$(getprop sys.boot_completed)" = "1" ] && [ -n "$(getprop vendor.mslg.mslgusrimg)" ] && [ -z "$(getprop sys.mslg.restart)" ]; then
    mount --bind /dev /data/rootfs/dev
    mount --bind /sys /data/rootfs/sys
    mount --bind /proc /data/rootfs/proc
    mount --bind /dev/msl/rdp /data/rootfs/tmp/msl/rdp
    mount -o ro -t ext4 "$(getprop vendor.mslg.mslgkingsoftimg)" /data/rootfs/opt/kingsoft
    mount -o ro -t ext4 "$(getprop vendor.mslg.mslgusrimg)" /data/rootfs/usr
    mount -o ro -t ext4 "$(getprop vendor.mslg.mslgappsimg)" /data/rootfs/opt/apps
    resetprop sys.mslg.restart 1
    if [ -f /data/rootfs/usr/bin/apt-key ]; then
      echo "挂载镜像文件完成" >> /data/media/0/MIUI/mslg/启动日志.log
    fi
fi

if [ "$(getprop vendor.setup.mslgrootfs)" = "1" ] && [ "$(getprop sys.boot_completed)" = "1" ] && [ -n "$(getprop vendor.mslg.mslgusrimg)" ] && [ "$(getprop sys.mslg.restart)" = "1" ]; then
    umount /data/rootfs/tablet
    mount --bind /storage/self/primary /data/rootfs/tablet
    /vendor/bin/clear-cajdata.sh
    /vendor/bin/clear-wpsdata.sh
    execution_time=$(($(date +%s) - start_time))
    sleep 1
    echo "启动完成，启动耗时：$execution_time 秒" >> /data/media/0/MIUI/mslg/启动日志.log
    mslgrootfs
fi