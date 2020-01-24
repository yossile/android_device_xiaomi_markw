#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE=markw
DEVICE_COMMON=msm8953-common
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

AOSP_ROOT="$MY_DIR"/../../..

HELPER="$AOSP_ROOT"/vendor/aosp/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "$1" != "" ]; do
    case $1 in
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
        -s | --section )        shift
                                SECTION=$1
                                CLEAN_VENDOR=false
                                ;;
        * )                     SRC=$1
                                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

# Initialize the helper
setup_vendor "$DEVICE_COMMON" "$VENDOR" "$AOSP_ROOT" true "$CLEAN_VENDOR"

extract "$MY_DIR"/proprietary-files-qc.txt "$SRC" "$SECTION"

if [ -s "$MY_DIR"/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" false "$CLEAN_VENDOR"

    extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"

    DEVICE_BLOB_ROOT="$AOSP_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary

    sed -i \
        's/\/system\/etc\//\/vendor\/etc\//g' \
        "$DEVICE_BLOB_ROOT"/vendor/lib/libmmcamera2_sensor_modules.so

;;
        vendor/lib64/hw/android.hardware.keymaster@3.0-impl.so|vendor/lib64/libsoftkeymasterdevice-v27.so|vendor/lib64/libkeymaster_messages-v27.so|vendor/lib64/libkeymaster_portable-v27.so|vendor/lib64/libkeymaster_staging-v27.so|vendor/lib64/libsoftkeymaster-v27.so)
                patchelf --replace-needed "libsoftkeymasterdevice.so" "libsoftkeymasterdevice-v27.so" "${2}"
                patchelf --replace-needed "libkeymaster_messages.so" "libkeymaster_messages-v27.so" "${2}"
                patchelf --replace-needed "libkeymaster_portable.so" "libkeymaster_portable-v27.so" "${2}"
                patchelf --replace-needed "libkeymaster_staging.so" "libkeymaster_staging-v27.so" "${2}"
                patchelf --replace-needed "libsoftkeymaster.so" "libsoftkeymaster-v27.so" "${2}"
                patchelf --set-soname $(basename "${2}") "${2}"
        ;;
fi

"$MY_DIR"/setup-makefiles.sh
