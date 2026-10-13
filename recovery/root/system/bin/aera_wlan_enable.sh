# Cold boot wifi fix
kmsg() { echo "<6>aera-wlan: $*" > /dev/kmsg; }

if [ ! -e /dev/wlan ]; then
    devname="$(cat /sys/class/wlan/wlan/dev 2>/dev/null)"
    if [ -n "${devname}" ]; then
        mknod /dev/wlan c "${devname%%:*}" "${devname##*:}" 2>/dev/null
        chmod 0660 /dev/wlan 2>/dev/null
    fi
fi
