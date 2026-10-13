#!/usr/bin/env bash
set -u

DEVICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="${DEVICE_DIR}/recovery/root"

DUMP="${1:-}"
[ -z "${DUMP}" ] && { echo "usage: $0 /path/to/stock/dump [--gpu] [--haptics]"; exit 1; }
[ ! -d "${DUMP}" ] && { echo "E: ${DUMP} is not a directory"; exit 1; }
shift || true

DO_GPU=0
DO_HAPTICS=0
[ $# -eq 0 ] && { DO_GPU=1; DO_HAPTICS=1; }
for arg in "$@"; do
    case "${arg}" in
        --gpu) DO_GPU=1 ;;
        --haptics) DO_HAPTICS=1 ;;
        *) echo "W: ignoring unknown option ${arg}" ;;
    esac
done

copied=0
missing=""

copy_one() {
    local src="${DUMP}/$1"
    local dst="${ROOT}/$1"
    if [ -f "${src}" ]; then
        mkdir -p "$(dirname "${dst}")"
        cp -f "${src}" "${dst}"
        copied=$((copied + 1))
    else
        missing="${missing}\n  $1"
    fi
}

if [ "${DO_GPU}" = "1" ]; then
    gpu_files=(
        vendor/lib64/egl/eglSubDriverAndroid.so
        vendor/lib64/egl/libEGL_adreno.so
        vendor/lib64/egl/libGLESv2_adreno.so
        vendor/lib64/egl/libq3dtools_adreno.so
        vendor/lib64/egl/libq3dtools_esx.so
        vendor/lib64/libadreno_utils.so
        vendor/lib64/libgsl.so
        vendor/lib64/libllvm-glnext.so
        vendor/lib64/libllvm-qgl.so
        vendor/lib64/libCB.so
        vendor/lib64/libgpudataproducer.so
        vendor/bin/hw/vendor.qti.hardware.display.allocator-service
        vendor/lib64/hw/android.hardware.graphics.mapper@4.0-impl-qti-display.so
        vendor/lib64/libgralloc.qti.so
        vendor/lib64/libgralloccore.so
        vendor/lib64/libgralloctypes.so
        vendor/lib64/libgrallocutils.so
        vendor/lib64/libdisplayconfig.qti.so
        vendor/lib64/libdisplaydebug.so
        vendor/lib64/libqdutils.so
        vendor/lib64/libdmabufheap.so
        vendor/lib64/libion.so
        vendor/lib64/libnativewindow.so
        vendor/lib64/libui.so
        vendor/lib64/android.hardware.common-V2-ndk.so
        vendor/lib64/android.hardware.graphics.allocator-V1-ndk.so
        vendor/lib64/android.hardware.graphics.allocator-V2-ndk.so
        vendor/lib64/android.hardware.graphics.allocator@2.0.so
        vendor/lib64/android.hardware.graphics.allocator@3.0.so
        vendor/lib64/android.hardware.graphics.allocator@4.0.so
        vendor/lib64/android.hardware.graphics.common-V4-ndk.so
        vendor/lib64/android.hardware.graphics.common-V6-ndk.so
        vendor/lib64/android.hardware.graphics.common@1.0.so
        vendor/lib64/android.hardware.graphics.common@1.1.so
        vendor/lib64/android.hardware.graphics.common@1.2.so
        vendor/lib64/android.hardware.graphics.mapper@2.0.so
        vendor/lib64/android.hardware.graphics.mapper@2.1.so
        vendor/lib64/android.hardware.graphics.mapper@3.0.so
        vendor/lib64/android.hardware.graphics.mapper@4.0.so
        vendor/lib64/vendor.display.config@1.0.so
        vendor/lib64/vendor.display.config@2.0.so
        vendor/lib64/vendor.qti.hardware.display.mapper@2.0.so
        vendor/lib64/vendor.qti.hardware.display.mapper@3.0.so
        vendor/lib64/vendor.qti.hardware.display.mapper@4.0.so
        vendor/lib64/vendor.qti.hardware.display.mapperextensions@1.0.so
        vendor/lib64/vendor.qti.hardware.display.mapperextensions@1.1.so
        vendor/lib64/vendor.qti.hardware.display.mapperextensions@1.2.so
        vendor/lib64/vendor.qti.hardware.display.mapperextensions@1.3.so
    )
    for f in "${gpu_files[@]}"; do copy_one "${f}"; done
fi

if [ "${DO_HAPTICS}" = "1" ]; then
    haptics_files=(
        vendor/lib64/vendor.qti.hardware.vibrator.impl.so
        vendor/lib64/vendor.qti.hardware.vibratorOL.impl.so
        vendor/lib64/vendor.qti.hardware.vibratorSel.impl.so
        vendor/lib64/libqtivibratoreffect.xiaomi.so
        vendor/lib64/libqtivibratoreffectoffload.so
        vendor/lib64/libmisight.so
        vendor/lib64/libaachaptics.so
        vendor/etc/vibrator/effect_0.bin
        vendor/etc/vibrator/effect_2.bin
        vendor/etc/vibrator/effect_3.bin
        vendor/etc/vibrator/effect_4.bin
        vendor/etc/vibrator/effect_5.bin
        vendor/firmware/goodix_cfg_group.bin
        vendor/firmware/goodix_firmware.bin
        vendor/firmware/aw8697_haptic.bin
        vendor/firmware/aw8697_rtp_1.bin
    )
    for f in "${haptics_files[@]}"; do copy_one "${f}"; done
fi

echo "I: copied ${copied} file(s) into ${ROOT}"
if [ -n "${missing}" ]; then
    echo -e "W: not present in the dump (skipped):${missing}"
    echo "I: files that are absent on your firmware are normal, e.g. the QTI"
    echo "I: vibrator impl libs only exist on units that use the QTI haptics path."
fi
echo "I: rebuild recovery and check that the Adreno renderer is used by looking"
echo "I: for \"AeraGpu\" messages in /tmp/recovery.log."
