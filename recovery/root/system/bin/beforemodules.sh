LOGF=/tmp/recovery.log

LOGMSG() {
    echo "I:$@" >> $LOGF
}

if grep -q "^goodix_core " /proc/modules 2>/dev/null; then
    if [ ! -d /sys/devices/platform/goodix_ts.0 ]; then
        if rmmod goodix_core 2>/dev/null; then
            LOGMSG "beforemodules: goodix_core unloaded (no goodix_ts.0 node)"
        else
            LOGMSG "beforemodules: could not unload goodix_core"
        fi
    fi
fi

exit 0
