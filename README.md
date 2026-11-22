
# PetPocket 🐾

PetPocket is a Flutter mobile application for pet owners who want to keep all of
their pets' care information organized in one place. Pet owners often track
vaccinations, medications, vet visits, and daily care routines across paper
booklets, notes, and photo galleries, which makes important dates easy to miss.

With PetPocket, users can create a separate profile for each of their pets and:

- Keep health records such as vaccinations, vet visits, medications, and parasite treatments
- Track weight changes over time with a simple chart
- Set feeding, medication, and appointment reminders with local notifications
- Manage a shopping list of supplies for each pet
- Store photos and documents in each pet's record

The app will be available in English and Turkish, with light and dark themes.
PetPocket is a record-keeping and reminder tool; it does not provide medical advice.

## Group Details

**CS310 Mobile Application Development – Fall 2026**
**Group:** 44

| Name | Student ID |
|------|------------|
| Ayça Ceylin Oktay | 35315 |
| Betül Merey | 33963 |

**Step 1 Coordinator:** Betül Merey

**Step 2 Coordinator:** Ayça Ceylin Oktay

## Tech Stack

- Flutter (Dart)
- Firebase Authentication
- Cloud Firestore
- Cloud Storage

## Step 2.2 – UI Implementation

In this step, the approved screens are implemented with working navigation and
placeholder (sample) data. Firebase integration will be added later.

### Flutter version

The project was tested with:

- Flutter 3.47.5 (stable channel)
- Dart 3.13.4


The app was tested in portrait mode on a small and a large Android emulator:

- Small Phone (360 × 640 dp)
- Pixel 9 (411 × 923 dp)
- Pixel 6 Pro (412 × 892 dp)

### How to run on an Android emulator

1. Clone the repository and open the project folder:
   ```bash
   git clone https://github.com/betlm/cs310-project.git
   cd cs310-project
   ```
2. Install the packages:
   ```bash
   flutter pub get
   ```
3. Start an Android emulator (Android Studio → Device Manager → ▶), then check
   that Flutter can see it:
   ```bash
   flutter devices
   ```
4. Run the app:
   ```bash
   flutter run
   ```
   If more than one device is listed, run `flutter run -d <device-id>` with
   the id shown by `flutter devices`.

The app can also be run on an iOS simulator with the same `flutter run` command.

### Running the tests

```bash
flutter analyze
flutter test
```

### Notes

- Sign in and sign up are UI-only in this step: any valid-looking email and a
  password of at least 8 characters open the app.
- All data is sample data and resets when the app is restarted.
- Ponçik's album photos are loaded from the internet with `Image.network`, so an
  internet connection is needed to see them. The other pets' photos are local
  assets.
- English / Turkish can be switched on the Welcome screen or in Preferences.
  Light / Dark can be switched on the Welcome screen, on Home, or in
  Preferences; the System option is available in Preferences.
