rm -rf /data/rootfs/home/xiaomi/core
export TMPDIR=/dev/msl/rdp
/vendor/bin/chroot /data/rootfs /bin/su - root <<EOF
/bin/MSLGd
EOF
