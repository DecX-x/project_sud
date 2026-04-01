# SmartBin Monitor

Aplikasi Flutter untuk monitoring tempat sampah pintar (smart bin) dengan data real-time, analitik, dan dukungan mode offline.

## Fitur Utama

- Monitoring level sampah secara real-time
- Status koneksi API (`Live` / `Offline`)
- Dashboard analitik
- Penyimpanan lokal (Hive) untuk fallback saat offline
- Onboarding flow
- Dukungan tema Light / Dark / System
- Dukungan multi-platform: Android, iOS, Web, Windows, macOS, Linux

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: go_router
- **Local Storage**: Hive
- **Chart**: fl_chart
- **HTTP Client**: http

## Prasyarat

Pastikan sudah terpasang:

- Flutter SDK (sesuai `pubspec.yaml`, Dart `^3.9.2`)
- Device/emulator, atau browser untuk target Web

Cek instalasi:

```bash
flutter --version
flutter doctor
```

## Cara Menjalankan (How to Run)

1. Masuk ke folder project:

```bash
cd <project-directory>
```

2. Install dependency:

```bash
flutter pub get
```

3. Generate file Hive (jika diperlukan setelah perubahan model):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Jalankan aplikasi:

```bash
flutter run
```

Contoh target spesifik:

```bash
flutter run -d chrome   # Web
flutter run -d android  # Android
flutter run -d ios      # iOS
```

## Build

```bash
flutter build apk        # Android APK
flutter build appbundle  # Android AAB
flutter build ios        # iOS
flutter build web        # Web
```

## Test & Lint

Jalankan static analysis:

```bash
flutter analyze
```

Jalankan test:

```bash
flutter test
```

Format code:

```bash
dart format lib test
```

## Struktur Folder Singkat

```text
lib/
├── core/
│   ├── constants/      # API constants
│   ├── providers/      # Riverpod providers
│   ├── router/         # Routing app
│   └── services/       # API & notification services
├── data/
│   ├── models/         # Data model (Hive)
│   └── repositories/   # Repository layer
└── presentation/
    ├── screens/        # Halaman UI
    └── widgets/        # Reusable widgets
```

## Konfigurasi API

Konfigurasi endpoint dan API key ada di:

`lib/core/constants/api_constants.dart`

Dokumentasi API lebih detail:

- `API_INTEGRATION.md`

## Catatan

- Saat startup, app akan mencoba fetch data dari API.
- Jika API gagal, app fallback ke cache/dummy data agar tetap bisa digunakan.
- Riwayat perubahan ada di:
  - `CHANGELOG.md`
