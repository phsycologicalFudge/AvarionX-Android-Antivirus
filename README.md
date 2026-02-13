<div align="center">

<img src="https://github.com/user-attachments/assets/1b8aca6b-1605-49d6-b542-76b99fb3438a" width="140" alt="ColourSwift logo">

# AvarionX Security

Antivirus for Android, offering the same protection features as mainstream AVs without paid tiers.  
Available on Google Play and GitHub.

## Important: Ads

Short answer: Github builds do NOT include ads

Long answer:
In order to fund the project, the play store version comes with ads. Users can purchase Pro to unlock additional app customisation features. To maintain balance between ecosystems, GitHub builds do not support Play Store Pro purchases. Sponsor certificates are used instead. However, Github builds will forever remain ad-free.

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

<br>

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

- **VX-Titanium Threat Intelligence (VTTI/VTTI Cloud)**  
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

## Network Protection

The Android build includes a DNS-based Network Protection layer powered by VTTI and is hosted on Cloudflare. It works by using Android's VpnService API to intercept DNS queries ONLY.

### How Does It Work?

- No registration required at all.
- DNS queries are sent to our cloud proxy.
- The proxy evaluates each request against multiple blocklist categories.
- Matching is performed using Bloom filters for high-speed, low-memory domain checks.
- CNAME chain inspection is performed to detect malicious domains.
- If a domain matches an enabled policy, it is blocked.
- Otherwise, the query is securely forwarded to an upstream resolver.

### Blocklists

Supported categories:

- Malware domains
- Phishing
- Ad domains
- Tracker domains
- Adult content
- Gambling
- Social media
- Romain domain set

### Plan Tiers

- Free plan is split into two tiers. Github users are not restricted on blocklists, whilst Google play users cannot use the 'ad-block' lists. This was a difficult but needed choice to fund the project.
- Pro plan enables unlimited queries per month.
- Monthly query caps only apply to the free tier (300,000 queries/pm).

### Privacy

- No HTTPS traffic is decrypted.
- No content inspection is performed.
- Only DNS query names and user filtering settings (blocklists, resolver preference) are sent to the proxy.
  
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

## Data sources

AvarionX makes use of publicly available threat intelligence and research datasets to complement internal detection systems.

Some external sources used during development and for reference include:

- **OISD**  
  A well maintained domain blocklists focused on ads, malware, and tracking domains.  
  https://oisd.nl/

- **Malicious Domains (romainmarcoux)**  
  A Curated list of known malicious and suspicious domains used for research and validation purposes.  
  https://github.com/romainmarcoux/malicious-domains


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
