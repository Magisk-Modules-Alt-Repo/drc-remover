#!/system/bin/sh

# if Magisk change its mount point in the future
MODDIR=${0%/*}

. "${MODDIR}/service-functions.sh"

(((waitAudioServer; remountFiles "$MODDIR")  0<&- &>"/dev/null" &) &)
