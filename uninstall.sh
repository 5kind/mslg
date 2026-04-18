tmp_list=\"MSLgRdp\"
dda=/data/dalvik-cache/arm
[ -d $dda"64" ] && dda=$dda"64"
for i in $tmp_list; do
	rm -f $dda/system@*@"$i"*
done
rm -rf /data/system/package_cache/*
rm -rf /data/app/*/com.xiaomi.mslgrdp
rm -rf /data/app/com.xiaomi.mslgrdp
if [ -f "$MODDIR/remove" ]; then
  umount /data/rootfs/tablet
  if [ ! -d /data/rootfs/tablet/Android ]; then
    rm -rf /data/rootfs
    rm -rf /data/media/0/MIUI/mslg
  fi
fi
# Don't modify anything after this
if [ -f $INFO ]; then
  while read LINE; do
    if [ "$(echo -n $LINE | tail -c 1)" == "~" ]; then
      continue
    elif [ -f "$LINE~" ]; then
      mv -f $LINE~ $LINE
    else
      rm -f $LINE
      while true; do
        LINE=$(dirname $LINE)
        [ "$(ls -A $LINE 2>/dev/null)" ] && break 1 || rm -rf $LINE
      done
    fi
  done < $INFO
  rm -f $INFO
fi