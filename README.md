<div align="center">

<img src="https://github.com/user-attachments/assets/1b8aca6b-1605-49d6-b542-76b99fb3438a" width="140" alt="ColourSwift logo">

# AvarionX Security

Ad-free antivirus for Android, offering the same protection features as mainstream AVs without paid tiers.  
Available on Google Play and GitHub.

<br>

<!-- Stats -->
<img src="https://img.shields.io/github/downloads/phsycologicalFudge/ColourSwift_AV/total?label=App%20downloads">
<img src="https://img.shields.io/github/v/release/phsycologicalFudge/ColourSwift_AV?label=App%20release">
<img src="https://img.shields.io/github/license/phsycologicalFudge/ColourSwift_AV">

<br>

<img src="https://img.shields.io/github/v/release/phsycologicalFudge/AVDatabase?label=VXPack">
<img src="https://img.shields.io/github/downloads/phsycologicalFudge/AVDatabase/total?label=VXPack%20downloads">

<br>

<a href="https://buymeacoffee.com/ryanfromcolourswift">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="60" alt="Buy me a coffee">
</a>

<br><br>

<!-- Store + Support -->
<a href="https://play.google.com/store/apps/details?id=com.colourswift.cssecurity">
  <img src="https://play.google.com/intl/en_gb/badges/static/images/badges/en_badge_web_generic.png" height="80">
</a>

</div>


## Overview

AvarionX helps you scan files and apps on your device for known malware using a local scanning engine and optional cloud-assisted threat intelligence.

- Scans files stored on your phone
- Real-Time Protection for the downloads folder
- Offline DNS filter for known bad domains
- Analyzes installed APKs  
- Uses local detection via VX-Titanium  
- Optional cloud assistance via VX-Titanium Threat Intelligence (VTTI) using file hashes  
- No accounts required  

The app works fully offline, except when downloading malware definition updates or using optional cloud checks.

### Detection model

AvarionX uses a dual detection model:

- **VX-Titanium**  
  The local, on-device scanning engine used for offline detection and analysis.

- **VX-Titanium Threat Intelligence (VTTI)**  
  A cloud-assisted threat intelligence service used for hash-based malware lookups and classification.  
  No file contents are uploaded, only cryptographic hashes when cloud checks are enabled.

## Download

Get the latest APK from GitHub Releases:

https://github.com/phsycologicalFudge/ColourSwift_AV/releases

## Screenshots

<div align="center">
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/1.jpg" width="220">
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/2.jpg" width="220">
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/3.jpg" width="220">
  <br><br>
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/4.jpg" width="220">
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/5.jpg" width="220">
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/6.jpg" width="220">
</div>

## Privacy

- No personal data collection  
- Files are never uploaded as cloud checks use hashes only  
- No user accounts  
- No tracking or analytics
- No Ads (Play store version does include ads)

## Open source status

This repository contains the full source code for the Android client and user interface.

The malware scanning engine however, is distributed as a prebuilt native library and is not open source.  
A trimmed reference file is provided for transparency:

https://github.com/phsycologicalFudge/ColourSwift_AV/blob/main/android/app/src/main/jniLibs/trimmed_Engine.rs

## Support me

If you like the project and want to support continued development, you can buy me a coffee here:

<div align="center">
  <a href="https://buymeacoffee.com/ryanfromcolourswift">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="50" alt="Buy me a coffee">
  </a>
</div>
PLEASE DM ME IF YOU BUY ME A COFFEE

## Join the discord!
https://discord.gg/VYubQJfcYM
