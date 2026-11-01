# Mynah

Android-first reading companion that helps you actually *finish* books: import your own EPUB/PDF files, listen with synced highlighting, and tap any word for an instant, on-device meaning and pronunciation. Fully offline after a one-time model download. No accounts, no cloud, no ads, no analytics.

## Features

- **Library** — import EPUB/PDF via the system picker; covers, progress, time left
- **Reader** — light/dark/sepia, font & spacing controls, every word tappable
- **Read-aloud** — system TTS with sentence + word highlighting, background playback, lock-screen/headset controls, sleep timer, smart rewind
- **Tap-a-word** — offline WordNet definitions plus an on-device LLM "meaning here"
- **Pronunciation** — CMUdict IPA, simple respelling, heteronym handling, per-book overrides
- **Spoiler-safe AI** — "Previously on…" recaps that only ever see text you've already read
- **Gentle habits** — daily goal ring, streaks with freezes, stats, reminders
- **Vocabulary** — saved words with spaced-repetition review and CSV export

## Stack

Flutter · Dart 3 · Riverpod · go_router · Drift (SQLite) · flutter_tts · audio_service · on-device Gemma via LiteRT-LM · WordNet + CMUdict (bundled SQLite)

## Setup

Requirements: Flutter (stable, 3.41+), Android SDK (min SDK 26), an ARM64 Android device.

```bash
git clone git@github.com:kart747/mynah.git
cd mynah
flutter pub get
flutter run            # with your phone connected via USB/wireless debugging
```

Release build:

```bash
flutter build apk --release --target-platform android-arm64
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

The on-device language model (~2.6 GB) is downloaded inside the app on first launch — it is not part of the repo or the APK.
