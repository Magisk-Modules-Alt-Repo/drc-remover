## DRC (Dynamic Range Control)  remover

This simple module disables DRC (Dynamic Range Control, i.e., a kind of compression) on all audio outputs (a 3.5mm jack, an internal speaker, bluetooth earphones, USB DAC's, etc.) if DRC has been enabled on a stock firmware. For example, smart phones and tablets whose SoC's have an SDM??? or SM???? model number usually enable DRC on all audio outputs, but those whose SoC's have an MT???? model number don't enable DRC on any audio output.<br/>
<br/>

This module behaves as follows:
<ol>
    <li>Checks whether this device enables DRC  or not. If so, then continues below, else exits.</li>
    <li>Copies /vendor/etc/*/audio_policy_configuration*.xml to $MODDIR/system/vendor/etc</li>
    <li>Edits $MODDIR/system/vendor/etc/*/audio_policy_configuration*.xml to replace
     'speaker_drc_enabled="true"' with 'speaker_drc_enabled="false"'.</li>
    <li>Overlays this modified one on /vendor/etc/*/audio_policy_configuration*.xml.</li>
</ol>
<br/>
<br/>
This module has been tested on LineageOS and ArrowOS ROM's, and phh GSI's (Android 10 & 11 & 12, Qualcomm & MediaTek SoC, and Arm32 & Arm64 combinations). But some custom ROM's (not stocks and GSI's) intendedly invert or change the meaning of 'speaker_drc_enabled' switch on context, then this module cannot disable DRC.
<br/><br/>

* See also my companion magisk module ["Audio misc. settings"](https://github.com/Magisk-Modules-Alt-Repo/audio-misc-settings) for simply improving audio quality with respect to the number of media volume steps and resampling distortion of the Android OS mixer (AudioFlinger), and my root script ["USB_SampleRate_Changer"](https://github.com/yzyhk904/USB_SampleRate_Changer) to change the sample rate of the USB (HAL) audio class driver and a 3.5mm jack on the fly like Bluetooth LDAC or Windows mixer to enjoy high resolution sound or to reduce resampling distortion (actually pre-echo, ringing and intermodulation) ultimately. 
<br/><br/>


## DISCLAIMER

* I am not responsible for any damage that may occur to your device, so it is your own choice to attempt this module.
<br/>

## Change logs

# v1.0.0
* Initial Release

##