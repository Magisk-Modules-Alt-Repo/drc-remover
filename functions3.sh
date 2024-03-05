#!/system/bin/sh

# This script functions will be used in customize.sh and service.sh
#

# Check whether Magisk magic mount compatible or not
function isMagiskMountCompatible()
{
    local tmp="$(magisk --path)"
    if [ -z "$tmp" ]; then
        return 1
    elif [ -d "${tmp}/.magisk/mirror/vendor" ]; then
        return 0
    else
        return 1
    fi
}

function no_need_this_module()
{
    ui_print "*********************************************************************************"
    ui_print " This module isn't needed! (because DRC hasn't been enabled on this device)"
    ui_print " DRC remover doesn't do anything on your device!"
    ui_print "     Please remove this module after rebooting"
    ui_print "*********************************************************************************"
}

function policy_file_not_found()
{
    ui_print "*********************************************************************************"
    ui_print " This module cannot find any audio policy file! "
    ui_print " DRC remover doesn't do anything on your device!"
    ui_print "     Please remove this module after rebooting"
    ui_print "*********************************************************************************"
}

# Get the active audio policy configuration fille from the audioserever

function getActivePolicyFile()
{
    dumpsys media.audio_policy | awk ' 
        /^ Config source: / {
            print $3
        }' 
}

# stopDRC has two args specifying a main audio policy configuration XML file (eg. audio_policy_configuration.xml) and its dummy to overide

function stopDRC()
{
     if [ $# -eq 2  -a  -r "$1"  -a  -w "$2" ]; then
        # Copy an original audio_policy_configuration.xml
        cp -f "$1" "$2"
        # Change audio_policy_configuration.xml file to remove DRC
        sed -i 's/speaker_drc_enabled[:space:]*=[:space:]*"true"/speaker_drc_enabled="false"/' "$2"
    fi
}

# Get the actual audio configuration XML file name, even for Xiaomi, OnePlus, etc.  stock devices
#    that may overlay another file on the dummy mount point file

function getActualConfigXML()
{
    if [ $# -eq 1 ]; then
        local dir=${1%/*}
        local fname=${1##*/}
        local sname=${fname%.*}

        if [ -r "${dir}/${sname}_sec.xml" ]; then
            echo "${dir}/${sname}_sec.xml"
        elif [ -e "${dir}_qssi"  -a  -r "${dir}_qssi/${fname}" ]; then
            # OnePlus stock pattern
            echo "${dir}_qssi/${fname}"
        elif [ "${dir##*/}"  = "sku_`getprop ro.board.platform`"  -a  -r "${dir%/*}/${fname}" ]; then
            # OnePlus stock pattern2
            echo "${dir%/*}/${fname}"
        elif [ -r "${dir}/audio/${fname}" ]; then
            # Xiaomi stock pattern
            echo "${dir}/audio/${fname}"
        elif [ -r "${dir}/${sname}_base.xml" ]; then
            echo "${dir}/${sname}_base.xml"
        else
            echo "$1"
        fi
    fi
}
