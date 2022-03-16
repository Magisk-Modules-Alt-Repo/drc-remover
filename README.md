## DRC (Dynamic Range Control)  remover

This simple module disables DRC (Dynamic Range Control, i.e., a kind of compression) on all audio outputs (a 3.5mm jack, an internal speaker, bluetooth earphones, USB DAC's, etc.) if DRC has been enabled on a stock firmware. For example, smart phones and tablets whose SoC's have an SDM??? or SM???? model number, usually enable DRC on all audio outputs, but whose SoC's have an MT???? model number don't enable DRC on any audio output.<br/>
<br/>

This module behaves as follows:
<ol>
    <li>Checks whether this device enables DRC  or not. If so, then continues below, else exits.</li>
    <li>Copies /vendor/etc/\*/audio_policy_configuration\*.xml to $MODDIR/system/vendor/etc</li>
    <li>Edits $MODDIR/system/vendor/etc/\*/audio_policy_configuration\*.xml to replace
     'speaker_drc_enabled="true"' with 'speaker_drc_enabled="false"'.</li>
    <li>Overlays this modified one on /vendor/etc/\*/audio_policy_configuration\*.xml.</li>
</ol>
<br/>
<br/>
This module has been tested on LineageOS and ArrowOS ROM's, and phh GSI's (Android 10 & 11 & 12, Qualcomm & MediaTek SoC, and Arm32 & Arm64 combinations). 

## DISCLAIMER

* I am not responsible for any damage that may occur to your device, 
   so it is your own choice to attempt this module.

## Change logs

# v1.0.0
* Initial Release

##