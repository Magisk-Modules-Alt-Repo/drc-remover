## DRC (Dynamic Range Control)  remover

This simple module disables DRC (Dynamic Range Control, i.e., compression) if DRC has been enabled in a stock firmware, e.g., smart phones and tablets having an SDM??? or SM???? model numbered SoC internally. <br/>
<br/>

This module behaves as follows:

* 1. check whether this device has been DRC enabled or not.<br>
    if so, then continue below, else exit.

* 2. copy /vendor/etc/*/audio_policy_configuration*.xml to $MODDIR/system/vendor/etc

* 3. edit $MODDIR/system/vendor/etc/*/audio_policy_configuration*.xml to replace
     'speaker_drc_enabled="true"' with 'speaker_drc_enabled="false"'.

* 4. overlay this modified one on /vendor/etc/*/audio_policy_configuration*.xml.

Tested on LineageOS based and ArrowOS ROMs (Android 10 & 11 & 12).

## DISCLAIMER

* I am not responsible for any damage that may occur to your device, 
   so it is your own choice to attempt this module.

## Change logs

# v1.0.0
* Initial Release

##
