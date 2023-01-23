#!/system/bin/sh

# if Magisk change its mount point in the future
    MODDIR=${0%/*}

. "$MODDIR/functions3.sh"

function reloadAudioServer()
{
    if [ -n "`getprop init.svc.audioserver`" ]; then
        setprop ctl.restart audioserver
        sleep 1.2
        if [ "`getprop init.svc.audioserver`" != "running" ]; then
            # workaround for Android 12 old devices hanging up the audioserver after "setprop ctl.restart audioserver" is executed
            local pid="`getprop init.svc_debug_pid.audioserver`"
            if [ -n "$pid" ]; then
                kill -HUP $pid 1>"/dev/null" 2>&1
            fi
        fi
    fi
}

# sleep some secs needed for Audioserver's preparation

function remountFile()
{
    local configXML
    
    # Set the active configuration file name retrieved from the audio policy server
    configXML="`getActivePolicyFile`"

    # Check if the audio policy XML file mounted by Magisk is still unmounted.
    # Some Qcomm devices from Xiaomi, OnePlus, etc. overlays another on it in a boot process
    # and phh GSI on Qcomm devices unmount it
    
    if [ -r "$configXML"  -a  -r "${MODDIR}/system${configXML}" ]; then
        cmp "$configXML" "${MODDIR}/system${configXML}" >"/dev/null" 2>&1
        if [ "$?" -ne 0 ]; then
            umount "$configXML" >"/dev/null" 2>&1
            umount "$configXML" >"/dev/null" 2>&1
            mount -o bind "${MODDIR}/system${configXML}" "$configXML"
            reloadAudioServer
        fi
    fi
}

(((sleep 32; remountFile)  0<&- &>"/dev/null" &) &)
