# debug
exec 2>/data/media/0/MIUI/mslg/安装日志.log
set -x

# 读取参数
Market_Name=`getprop ro.product.marketname`
Device=`getprop ro.product.device`
Model=`getprop ro.product.model`
Brand=`getprop ro.product.brand`
Name=`getprop ro.product.name`
Version=`getprop ro.build.version.incremental`
Android=`getprop ro.build.version.release`
CPU_ABI=`getprop ro.product.cpu.abi`
Mediatek=`getprop ro.vendor.mediatek.platform`
Time=$(date "+%m.%d %H:%M")

## 执行安装模块
ui_print "- 正在释放文件..."
case "$ARCH" in
    arm64) Type=arm64 Wenj=arm64-v8a;;
    arm)   Type=arm   Wenj=armeabi-v7a;;
    x64)   Type=x86_64 Wenj=x86_64;;
    x86)   Type=x86   Wenj=x86;;
    *)     Type=arm64 Wenj=arm64-v8a;; # 默认 arm64
esac
ui_print "- 你的设备为 $Type 架构"
# 创建 OAT 目录
mkdir -p "$MODPATH/system/vendor/app/MSLgRdp/oat/$Type"
# 清理旧数据
ui_print "- 正在清理旧版本残留..."
local pkg="com.xiaomi.mslgrdp"
for dir in "/data/data/$pkg" "/data/user/0/$pkg" "/data/user_de/0/$pkg" "/data/app/*/$pkg*"; do
  rm -rf $dir >/dev/null 2>&1
done
# 清理 dalvik-cache
rm -f /data/dalvik-cache/*/*MSLgRdp* >/dev/null 2>&1
# 创建 mslg 文件夹
mkdir -p /sdcard/MIUI/mslg
