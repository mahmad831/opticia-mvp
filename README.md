# Opticia MVP (Flutter)

This repository contains the **MVP** for *Opticia — Cursor Control Through Eye Movement*.

## Build without installing Flutter locally (Codemagic)
1. Push this folder to a new **GitHub** repo (or zip upload in Codemagic).
2. Sign in at **https://codemagic.io/** → Create new app → connect the repo → choose **codemagic.yaml**.
3. Start the **Android Debug APK** workflow.
4. After it finishes, download the artifact: `app-debug.apk` and install it on your Android device.

> This repo includes a `codemagic.yaml` which auto-runs `flutter create .` to scaffold the Android project,
> adds camera permissions, then builds an APK.

## App Flow (MVP)
- Permissions → Face **Register/Login** → Home → **START** (gaze cursor) → **Sensitivity**, **Sound**, **Manual**.

## Notes
- The gaze is a coarse heuristic (left/right/up/down) using ML Kit landmarks.
- For system-wide clicks, implement an Android **Accessibility Service** (post-MVP).
