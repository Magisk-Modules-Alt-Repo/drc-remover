#!/system/bin/sh

[ -z "$(magisk --path)" ] && alias magisk='ksu-magisk'

. "$MODPATH/functions3.sh"

if ! isMagiskMountCompatible; then
    abort '  ***
  Aborted by no Magisk-mirrors:
    try again either
      a.) with official Magisk v27.0 (mounting mirrors), or
      b.) after installing "Compatible Magisk-mirroring" Magisk module and rebooting
  ***'
fi

# Replace audio_policy_configuration*.xml
REPLACE="
"

# Set the active configuration file name retrieved from the audio policy server
configXML="`getActivePolicyFile`"

# configXML is usually placed under "/vendor/etc" (or "/vendor/etc/audio"), but
# "/my_product/etc" and "/odm/etc" are used on ColorOS (RealmeUI) and OxygenOS(?)
case "$configXML" in
    /vendor/etc/* | /my_product/etc/* | /odm/etc/* | /system/etc/* | /product/etc/* )
        MAGISKPATH="$(magisk --path)"
        if [ -n "$MAGISKPATH"  -a  -r "$MAGISKPATH/.magisk/mirror${configXML}" ]; then
            # Don't use "$MAGISKPATH/.magisk/mirror/system${configXML}" instead of "$MAGISKPATH/.magisk/mirror${configXML}".
            # In some cases, the former may link to overlaied "${configXML}" by Magisk itself (not original mirrored "${configXML}".
            mirrorConfigXML="$MAGISKPATH/.magisk/mirror${configXML}"
            
        else
            original_policy_file_not_found
            abort " Abort installation!"
            
        fi
        
        # If DRC is enabled, modify audio policy configuration to stop DRC
        grep -e "speaker_drc_enabled[[:space:]]*=[[:space:]]*\"true\"" "$mirrorConfigXML" >"/dev/null" 2>&1
        if [ "$?" -eq 0 ]; then
            case "${configXML}" in
                /system/* )
                    configXML="${configXML#/system}"
                ;;
            esac
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
            
            # If "${configXML}" isn't symbolically linked to "$/system/{configXML}", 
            #   disable Magisk's "magic mount" and mount "${configXML}" by this module itself in "service.sh"
            if [ ! -e "/system${configXML}" ]; then
                touch "$MODPATH/skip_mount"
            fi
            
        else
            no_need_this_module
            abort " Abort installation!"
            
        fi
        ;;
    * )
            policy_file_not_found
            abort " Abort installation!"
        ;;
esac

rm -f "$MODPATH/LICENSE" "$MODPATH/README.md" "$MODPATH/changelog.md" "$MODPATH/functions3.sh"
