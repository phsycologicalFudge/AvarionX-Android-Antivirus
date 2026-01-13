## AvarionX Security

<img src="https://github.com/user-attachments/assets/65938060-807c-4630-ba5a-ea7d35d51ed8" width="140" alt="ColourSwift logo">

ColourSwift Security is an ad-free antivirus app for Android, offering all the paid features mainstream AVs offer without paid tiers. It is available on both Google Play and GitHub.

<p>
  <img src="https://img.shields.io/github/downloads/phsycologicalFudge/ColourSwift_AV/total?label=App%20downloads">
  <img src="https://img.shields.io/github/v/release/phsycologicalFudge/ColourSwift_AV?label=App%20release">
  <img src="https://img.shields.io/github/v/release/phsycologicalFudge/AVDatabase?label=VXPack">
  <img src="https://img.shields.io/github/downloads/phsycologicalFudge/AVDatabase/total?label=VXPack%20downloads">
  <img src="https://img.shields.io/github/license/phsycologicalFudge/ColourSwift_AV">
</p>

<p>
  <a href="https://play.google.com/store/apps/details?id=com.colourswift.cssecurity">
    <img src="https://play.google.com/intl/en_gb/badges/static/images/badges/en_badge_web_generic.png"
         height="80"
         alt="Get it on Google Play">
  </a><br>
  Available on Google Play (10,000+ installs)
</p>

---

## Overview

ColourSwift Security helps you scan files and apps on your device for known malware using a local scanning engine and optional cloud-assisted threat intelligence.

- Scans files stored on your phone
- Real-Time Protection for the downloads folder
- Offline DNS filter for known bad domains
- Analyzes installed APKs  
- Uses local detection via VX-Titanium  
- Optional cloud assistance via VX-Titanium Threat Intelligence (VTTI) using file hashes   
- No accounts required  

The app works fully offline, except when downloading malware definition updates or using optional cloud checks.

---

### Detection model

ColourSwift Security uses a dual detection model:

- **VX-Titanium**  
  The local, on-device scanning engine used for offline detection and analysis.

- **VX-Titanium Threat Intelligence (VTTI)**  
  A cloud-assisted threat intelligence service used for hash-based malware lookups and classification.
  No file contents are uploaded, only cryptographic hashes when cloud checks are enabled.

---

## Download

Get the latest APK from GitHub Releases:

https://github.com/phsycologicalFudge/ColourSwift_AV/releases

---

## Screenshots

<p float="left">
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/1.jpg" width="240">
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/2.jpg" width="240">
  <img src="https://raw.githubusercontent.com/phsycologicalFudge/ColourSwift_AV/main/assets/gitImages/3.jpg" width="240">
</p>

---

## Privacy

- No personal data collection  
- Files are never uploaded as cloud checks use hashes only  
- No user accounts  
- No tracking or analytics  

---

## Open source status

This repository contains the full source code for the Android client and user interface.

The malware scanning engine however, is distributed as a prebuilt native library and is not open source.  
A trimmed reference file is provided for transparency:

https://github.com/phsycologicalFudge/ColourSwift_AV/blob/main/android/app/src/main/jniLibs/trimmed_Engine.rs

---

## Engine usage by other developers

Developers are allowed to use VX-Titanium (the engine) in their own Android apps.

This is permitted under the following conditions:

- The engine must be accessed through the provided bridge interface
- Malware database updates must follow the official update format
- The engine must be credited by name in the app
- The app must clearly state that it is not affiliated with ColourSwift
- The client side code must be publically visible. 
- The engine may not be claimed as original work
- Developers are responsible for integrating and updating the engine in their own app

Detailed terms are available in `ENGINE_LICENSE.md`.

## Commercial licensing

VX-Titanium will be available under alternative commercial licensing terms for
organisations that require closed-source integration, custom distribution,
or enterprise support.

Commercial licensing is not covered by this repository or by
ENGINE_LICENSE.md.

For commercial enquiries, contact:
support@colourswift.com

Join the discord!
https://discord.gg/VYubQJfcYM
