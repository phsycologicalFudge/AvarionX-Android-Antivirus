<p align="center">
  <img src="assets/icons/ic_launcher_ax.png" width="92" alt="AvarionX Security logo">
</p>

<div align="center">

# AvarionX Security

### Android malware protection without ads, tracking, or locked core features.

AvarionX combines local malware scanning, optional hash-based cloud intelligence, download monitoring, DNS filtering, APK analysis, and Guardian Mode for ransomware-style behaviour detection.

[![Release](https://img.shields.io/github/v/release/phsycologicalFudge/AvarionX-Android-Antivirus?logo=github&label=release&color=6366f1)](https://github.com/phsycologicalFudge/AvarionX-Android-Antivirus/releases)
[![Downloads](https://img.shields.io/github/downloads/phsycologicalFudge/AvarionX-Android-Antivirus/total?logo=github&label=downloads&color=10b981)](https://github.com/phsycologicalFudge/AvarionX-Android-Antivirus/releases)
[![License](https://img.shields.io/github/license/phsycologicalFudge/AvarionX-Android-Antivirus?label=license&color=64748b)](LICENSE)

[![VX-TITANIUM](https://img.shields.io/badge/VX--TITANIUM-V9-7c3aed?labelColor=020617)](https://github.com/phsycologicalFudge/AvarionX-Android-Antivirus)
[![VXPack](https://img.shields.io/github/v/release/phsycologicalFudge/AVDatabase?label=VXPack&color=0ea5e9)](https://github.com/phsycologicalFudge/AVDatabase/releases)
[![VXPack downloads](https://img.shields.io/github/downloads/phsycologicalFudge/AVDatabase/total?label=VXPack%20downloads&color=f97316)](https://github.com/phsycologicalFudge/AVDatabase/releases)

<a href="https://buymeacoffee.com/ryanfromcolourswift">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="48" alt="Buy me a coffee">
</a>

</div>

## What is AvarionX?

AvarionX Security is an Android antivirus built around user privacy.

It can scan files and APKs directly on your device, monitor new downloads, check known malicious domains, and use optional cloud intelligence for hash lookups. The app does not use ads, analytics, or paid protection tiers.

Cloud checks are optional. When enabled, AvarionX sends file hashes for lookup, not the file contents.

## Protection layers

| Layer | What it does |
|---|---|
| **VX-TITANIUM** | Local malware scanning engine for files and APKs. |
| **VTTI Cloud** | Proprietary cloud Intelligence Platform, including hash checking |
| **Real-Time Protection** | Monitors new downloads and recently added files. |
| **Guardian Mode** | Watches for ransomware-style file behaviour. |
| **APK analysis** | Checks installed or selected APKs for suspicious indicators. and creates a detailed report |

## The Engine's Architecture

AvarionX Antivirus (CS Security) operates through a multi-layered detection pipeline powered by VX-Titanium.

1. Cloud Hash Layer: A fast check on an extremely large historical and current corpus of over 200 million unique malware hashes
2. Hash Layer: Comparing both SHA256 and MD5 fingerprints against known malware lists
3. Signature Layer: Custom byte signitures checked against apk containers, dex and native libraries.
4. Heuristic Layer: Machine learning based behaviour analysis for APKs

### Machine Learning (ML+)

AvarionX Security includes a dual ML system named ML+

* On-Device: Runs on-device with no remote processing or user telemetry
* MUniverse Tag: Suspicious applications that meet the scoring system's requirements are dubbed with a MUniverse (Malware Universe) tag

## Guardian Mode

By utilizing shizuku, Guardian Mode can monitor app behaviour that android would normally keep out of reach. When an app starts changing files, AvarionX monitors it, assessing the likelihood on destructive behaviour.
Guardian Mode is currently focused on ransomware-style behaviour. More behaviour categories will be added in future updates.

## Screenshots

<table>
  <tr>
    <td width="20%" align="center">
      <img src="assets/gitImages/1.jpg" width="190" alt="AvarionX protection menu"><br>
      <sub><strong>Home screen</strong></sub>
    </td>
    <td width="20%" align="center">
      <img src="assets/gitImages/2.jpg" width="190" alt="AvarionX home screen"><br>
      <sub><strong>Features list</strong></sub>
    </td>
    <td width="20%" align="center">
      <img src="assets/gitImages/3.jpg" width="190" alt="AvarionX Cleaner Pro"><br>
      <sub><strong>Scanning mode</strong></sub>
    </td>
    <td width="20%" align="center">
      <img src="assets/gitImages/4.jpg" width="190" alt="AvarionX Smart Scan"><br>
      <sub><strong>APK Analyser</strong></sub>
    </td>
    <td width="20%" align="center">
      <img src="assets/gitImages/5.jpg" width="190" alt="AvarionX dark mode"><br>
      <sub><strong>Settings Screen</strong></sub>
    </td>
  </tr>
</table>

## Privacy model

AvarionX is designed to avoid unnecessary data collection.

- No advertisements
- No tracking or analytics
- No HTTPS traffic decryption
- No content inspection
- No file uploads for cloud checks
- Hash-only cloud lookups when VTTI is enabled
- Local scanning works offline

<h2>Guardian Mode Demo</h2>

<p align="center">
  <a href="https://streamable.com/07jwwd">
    <img src="https://cdn-cf-east.streamable.com/image/07jwwd.jpg" width="180" alt="Watch demo video">
  </a>
</p>
