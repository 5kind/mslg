##########################################################################################
#
# MMT Extended Config Script
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Uncomment and change 'MINAPI' and 'MAXAPI' to the minimum and maximum android version for your mod
# Uncomment DYNLIB if you want libs installed to vendor for oreo+ and system for anything older
# Uncomment PARTOVER if you have a workaround in place for extra partitions in regular magisk install (can mount them yourself - you will need to do this each boot as well). If unsure, keep commented
# Uncomment PARTITIONS and list additional partitions you will be modifying (other than system and vendor), for example: PARTITIONS="/odm /product /system_ext"
#MINAPI=21
#MAXAPI=25
#DYNLIB=true
#PARTOVER=true
#PARTITIONS=""

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  ui_print "- 正在设置权限..."
  # 设置基础 vendor 权限
  set_perm_recursive "$MODPATH/system/vendor" 0 2000 0755 0644 u:object_r:vendor_file:s0

  # 设置应用权限
  set_perm_recursive "$MODPATH/system/vendor/app" 0 0 0755 0644 u:object_r:vendor_app_file:s0

  # 设置执行程序权限
  set_perm_recursive "$MODPATH/system/vendor/bin" 0 2000 0755 0755 u:object_r:mslgd_exec:s0
}

##########################################################################################
# MMT Extended Logic - Don't modify anything after this
##########################################################################################

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh
