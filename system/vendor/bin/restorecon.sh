chcon -R u:object_r:mslg_rootfs_file:s0 /dev/msl
chcon -R u:object_r:mslg_rootfs_file:s0 /dev/shm

target_context="u:object_r:mslg_rootfs_file:s0"

if [ -f /data/rootfs/version.txt ]; then
    exit 0
else
    chcon -R $target_context /data/rootfs
fi

