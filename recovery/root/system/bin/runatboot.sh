#!/system/bin/sh
#
# Runs on recovery startup (AERA calls /system/bin/runatboot.sh).
#

LOGF=/tmp/recovery.log

LOGMSG() {
    echo "I:$@" >> $LOGF
}

reset_touch() {
    if [ -d /sys/devices/platform/goodix_ts.0 ]; then
        LOGMSG "Resetting Goodix touchscreen post screen blank..."
        echo 1 > /sys/devices/platform/goodix_ts.0/irq_info
        echo 1 > /sys/devices/platform/goodix_ts.0/reset
    else
        LOGMSG "Goodix touchscreen sysfs not present; skipping reset..."
    fi
}

load_global() {
    [ -e /config/usb_gadget/g1/strings/0x409/product ] && \
        echo "POCO F5" > /config/usb_gadget/g1/strings/0x409/product
    resetprop ro.aera.device_model "POCO F5" 2>/dev/null
    resetprop ro.product.model "POCO F5" 2>/dev/null
    LOGMSG "runatboot: POCO F5 (global) props set"
}

load_cn() {
    [ -e /config/usb_gadget/g1/strings/0x409/product ] && \
        echo "Redmi Note 12 Turbo" > /config/usb_gadget/g1/strings/0x409/product
    resetprop ro.aera.device_model "Redmi Note 12 Turbo" 2>/dev/null
    resetprop ro.product.model "Redmi Note 12 Turbo" 2>/dev/null
    LOGMSG "runatboot: Redmi Note 12 Turbo (CN) props set"
}

SCRIPT_NAME="$(basename "$0")"

LOGMSG "---$SCRIPT_NAME start---"

region=$(getprop ro.boot.hwc)
LOGMSG "runatboot: detected region: ${region:-unknown}"

case "$region" in
    CN) load_cn ;;
    *)  load_global ;;
esac

reset_touch

LOGMSG "---$SCRIPT_NAME end---"
exit 0
