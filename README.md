# Vedic Booking – Pandit App

A Flutter application for pandits to manage ritual bookings, track earnings, and handle service requests. Built as a Trionova technical assessment.

---

## Features

- **Splash Screen** – Animated logo with auto-navigation
- **Home Dashboard** – Availability toggle, today's stats grid, pending booking requests, Muhurtha card
- **My Bookings** – Stats overview card, filter chips (All / Pending / Confirmed / Completed / Cancelled), search, pull-to-refresh
- **Booking Details** – Accept / Decline actions, payment breakdown, map placeholder, pending/confirmed/in-progress states
- **OTP Verification** – 4-digit PIN entry (mock OTP: **1234**) to start a ritual
- **Ritual Progress** – Live elapsed timer, customer details, End Ritual confirmation
- **Earnings** – Monthly total, quick stats card, service performance bars, recent transactions, Withdraw button
- **Profile** – Avatar with edit badge, straddling stats card, Account & Services menu sections, theme toggle, Sign Out
- **Subscription** – Three plan tiers (Sacred Basic / Sacred Pro / Sacred Elite)
- **Dark Mode** – Full light/dark theme support via toggle on profile screen

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart 3) |
| State Management | Riverpod 2.x (`ChangeNotifierProvider`) |
| Local Storage | Hive (bookings), SharedPreferences (theme) |
| Architecture | Clean Architecture (feature-based, data/domain/presentation) |
| UI | Material 3, custom `AppColors`, `AppTextStyles`, Poppins font |
| Animations | `flutter_animate`, `AnimatedSwitcher` |
| OTP Input | Pinput |

---

## Prerequisites

- Flutter SDK **3.10+** (verify with `flutter --version`)
- Dart SDK **3.0+**
- Android Studio **Hedgehog** or later (or VS Code with Flutter extension)
- Android SDK with Build Tools **34+**
- A connected Android device or emulator (API 21+)

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/vijayRajamnickam/vedic_booking_flutter.git
cd vedic_booking_flutter
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app (debug mode)

```bash
flutter run
```

> Connect an Android device via USB or start an emulator before running.

### 4. Build a release APK

```bash
flutter build apk --release
```

The output APK will be located at:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Mock Credentials

| Field | Value |
|---|---|
| OTP (Ritual Verification) | **1234** |

All booking data is loaded from `assets/json/mock_data.json`. No backend or network connection is required.

---

## Project Structure

```
lib/
├── core/
│   ├── config/          # Routes, text styles, theme provider
│   ├── constants/       # AppColors, AppStrings, AppConstants
│   └── widgets/         # Shared widgets (BookingCardWidget, ShimmerList)
└── ui/
    └── features/
        ├── splash/
        ├── home/
        ├── bookings/    # My Bookings, Booking Details, OTP, Ritual Progress
        ├── earnings/
        └── profile/     # Profile, Subscription
```

---

## Running on a Physical Device

1. Enable **Developer Options** on your Android device
2. Enable **USB Debugging**
3. Connect via USB and run `flutter devices` to confirm detection
4. Run `flutter run` to deploy

---

## APK Installation (Sideload)

1. Transfer `app-release.apk` to your Android device
2. Open the file and tap **Install**
3. If prompted, allow installation from unknown sources under Settings → Security

---

## Architecture Notes

Each feature follows Clean Architecture:

```
feature/
├── data/
│   ├── model/           # Data models (Hive entities)
│   └── repository/      # Data source (mock JSON / Hive)
├── domain/
│   └── entity/          # Domain entities
└── presentation/
    ├── provider/         # ChangeNotifier providers
    └── screens/         # UI screens and widgets
```

State is lifted into `ChangeNotifierProvider`s and consumed via `ConsumerStatefulWidget` / `ConsumerWidget`.

---

## License

Submitted as part of a Trionova technical assessment. Not licensed for public distribution.
