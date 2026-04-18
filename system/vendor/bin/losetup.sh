if [[ $DEBUG == "true" ]]; then
  exec 2>/storage/emulated/0/MIUI/mslg/debug_losetup.log
  set -x
fi

usrimg=$(getprop vendor.mslg.mslgusrimg)
  if [[ $usrimg == "/dev/block/loop"* ]]; then
    echo "has already losetup, nothing to do"
    exit 1
  else
    rm -rf /data/rootfs/tmp/*
    mkdir -p /data/rootfs/tmp/msl/rdp
    chmod -R 0755 /data/rootfs/tmp/msl
    dir="/data/rootfs"
    for file in "$dir"/mslg*; do
      cur_loop=`losetup -f`
      while  [[ $cur_loop != "/dev/block/loop"* ]]
      do
        sleep 1
        cur_loop=`losetup -f`
      done
      losetup -r $cur_loop $file
      setprop vendor.mslg."$(basename "$file")" $cur_loop
    done
    sleep 1
    usrimgloop=`losetup -f`
    while  [[ $usrimgloop != "/dev/block/loop"* ]]
    do
      sleep 1
      usrimgloop=`losetup -f`
    done
    find "/data/rootfs" -type f -name "mslgusrimg" | while read -r file; do
    losetup -r $usrimgloop "$file"
    done
    setprop vendor.mslg.mslgusrimg $usrimgloop
  fi

