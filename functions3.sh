#!/system/bin/sh

# This script functions will be used in customize.sh, post-fs-data mode, services mode and uninstall mode
#

function no_need_this_module()
{
  ui_print "*****************************************************************"
  ui_print " This module isn't needed because this device hasn't been DRC enabled! "
  ui_print "*****************************************************************"
}

function policy_file_not_found()
{
  ui_print "********************************************"
  ui_print " This module cannot find any audio policy file! "
  ui_print "********************************************"
}

# Get the active audio policy configuration fille from the audioserever
function getActivePolicyFile()
{
    dumpsys media.audio_policy | awk ' 
        /^ Config source: / {
            print $3
        }' 
}

function stopDRC()
{
    # stopDRC has two args specifying a main audio policy configuration XML file (eg. audio_policy_configuration.xml) and its modified one to overlay

     if [ $# -eq 2  -a  -r "$1"  -a  -w "$2" ]; then
        # Copy an original audio_policy_configuration.xml
        cp -f "$1" "$2"
        # Change audio_policy_configuration.xml file to remove DRC
        sed -i 's/speaker_drc_enabled[:space:]*=[:space:]*"true"/speaker_drc_enabled="false"/' "$2"
    fi
}
