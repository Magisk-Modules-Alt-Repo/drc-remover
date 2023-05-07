#!/system/bin/sh

. "$MODPATH/functions3.sh"

# Replace audio_policy_configuration*.xml
REPLACE="
"

# Set the active configuration file name retrieved from the audio policy server
configXML="`getActivePolicyFile`"

case "$configXML" in
    /vendor/etc/* | /my_product/etc/* | /odm/etc/* )
        # If DRC is enabled, modify audio policy configuration to stop DRC
        # /my_product/etc & /odm/etc are for ColorOS (RealmeUI) and OxygenOS(?)
        MAGISKPATH="$(magisk --path)"
        if [ -n "$MAGISKPATH"  -a  -r "$MAGISKPATH/.magisk/mirror${configXML}" ]; then
            # Don't use "$MAGISKPATH/.magisk/mirror/system${configXML}" instead of "$MAGISKPATH/.magisk/mirror${configXML}".
            # In some cases, the former may link to overlaied "${configXML}" by Magisk itself (not original mirrored "${configXML}".
            mirrorConfigXML="$MAGISKPATH/.magisk/mirror${configXML}"
        else
            mirrorConfigXML="$configXML"
        fi
        grep -e "speaker_drc_enabled[[:space:]]*=[[:space:]]*\"true\"" "$mirrorConfigXML" >"/dev/null" 2>&1
        if [ "$?" -eq 0 ]; then
            modConfigXML="$MODPATH/system${configXML}"
            mkdir -p "${modConfigXML%/*}"
            touch "$modConfigXML"
            mirrorConfigXML="`getActualConfigXML \"${mirrorConfigXML}\"`"
            stopDRC "$mirrorConfigXML" "$modConfigXML"
            chmod 644 "$modConfigXML"
            chcon u:object_r:vendor_configs_file:s0 "$modConfigXML"
            chown root:root "$modConfigXML"
            chmod -R a+rX "${modConfigXML%/*}"
            REPLACE="/system${configXML}"
        else
            no_need_this_module
            touch "$MODPATH/skip_mount"
            rm -f "$MODPATH/service.sh"
            rm -f "$MODPATH/functions3.sh"
        fi
        ;;
    * )
            policy_file_not_found
            touch "$MODPATH/skip_mount"
            rm -f "$MODPATH/service.sh"
            rm -f "$MODPATH/functions3.sh"
        ;;
esac
