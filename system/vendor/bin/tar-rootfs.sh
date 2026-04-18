device=$(getprop ro.product.device)
if [[ $device == "yudi" ]]; then
if [ -e "/data/vendor/mslg/rootfs/version.txt" ]; then
mv /data/vendor/mslg/rootfs/* /data/rootfs/
rm -rf /data/vendor/mslg/rootfs
fi
fi
if [ -e "/data/rootfs/home/xiaomi/.config/Kingsoft/Office.conf" ]; then
mv /data/rootfs/home/xiaomi/.config/Kingsoft/Office.conf /data/rootfs/home/xiaomi/.config/Kingsoft/Office.conf_used
fi
if [ -e "/data/rootfs/home/xiaomi/.config/Kingsoft/WPSCloud.conf" ]; then
mv /data/rootfs/home/xiaomi/.config/Kingsoft/WPSCloud.conf /data/rootfs/home/xiaomi/.config/Kingsoft/WPSCloud.conf_used
fi

tar -xvf  /vendor/etc/assets/$1 -C /data/rootfs

if [ -e "/data/rootfs/home/xiaomi/.config/Kingsoft/Office.conf_used" ]; then
mv /data/rootfs/home/xiaomi/.config/Kingsoft/Office.conf_used /data/rootfs/home/xiaomi/.config/Kingsoft/Office.conf
fi
if [ -e "/data/rootfs/home/xiaomi/.config/Kingsoft/WPSCloud.conf_used" ]; then
mv /data/rootfs/home/xiaomi/.config/Kingsoft/WPSCloud.conf_used /data/rootfs/home/xiaomi/.config/Kingsoft/WPSCloud.conf
fi

resetprop persist.vendor.unzip.mslgrootfs disable
