#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/marble

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Release name
PRODUCT_RELEASE_NAME := marble

## Device identifier
PRODUCT_DEVICE := marble
PRODUCT_NAME := twrp_marble
PRODUCT_BRAND := POCO
PRODUCT_MODEL := POCO F5
PRODUCT_MANUFACTURER := Xiaomi

# Assert
TARGET_OTA_ASSERT_DEVICE := marble,marblein

# Theme
AERA_STATUS_ICONS_ALIGN := center
#AERA_Y_OFFSET := 99
#AERA_H_OFFSET := -99

# Strongbox Device Decryption (OMAPI/se_omapi).'
#AERA_INCLUDE_OMAPI := true
