# Discover Bremen — The Fifth Musician

A small Flutter app for the BIP course *Mobile Programming and Technologies*
(HSB Bremen) by Mohamad Alaskari.

The Bremen Town Musicians never reached Bremen. In this app you are the
**fifth musician**: you walk to four places in the old town, and every visit
frees one animal. When all four are free, the band is complete. You drop a
coin into the real *Bremer Loch* and the band plays for you.

| Stop | Place | Animal | Instrument (Grimm tale) |
|---|---|---|---|
| 1 | Town Musicians statue (Marktplatz) | 🐴 Donkey | lute |
| 2 | Schlachte (Weser) | 🐶 Dog | kettledrums |
| 3 | Schnoor Quarter (Altstadt) | 🐱 Cat | night music |
| 4 | St. Petri Cathedral (Domshof) | 🐓 Rooster | a good voice |

## Run it

Needs Flutter stable (built and tested with Flutter 3.47.7 / Dart 3.13).

```bash
flutter pub get
flutter run -d chrome        # or an Android emulator / phone
flutter test                 # 13 widget tests
flutter analyze              # must say: No issues found!
```

On Windows, the project path contains spaces. Web and tests work. If an
Android build ever fails because of the path, move the project to
`D:\dev\discover_bremen`.

## What to try

1. **Onboarding:** three story pages. Enter your name on the last one.
2. **Home:** the route with 4 stops in a `ListView.builder`. Tap a stop.
3. **Details:** tap **Mark as Visited**. The stamp slams in, a voice bubble
   pops up and a snackbar offers **UNDO**. Then tap **Back to your route**.
   The stop now shows the stamp, a green trail and ✅, and the animal stands
   in the Musician Tower.
4. **Hear your band:** plays the band song with one instrument per freed animal.
5. After 4 stops: **Band complete** (certificate with your name) →
   **Drop a coin at the Bremer Loch** → tap the coin → concert.
   **New journey** starts again with 0 stops.

The speaker icon mutes every sound. Every sound has a visual twin (stamp,
voice bubble, tower), so the app is fully usable with the sound off.

## How the brief is covered

| Requirement | Where |
|---|---|
| List of ≥ 3 places (`ListView.builder`) | `lib/screens/home_screen.dart`, one `RouteStopTile` per stop |
| Details: name, short description, icon/image, Mark as Visited | `lib/screens/place_details_screen.dart` |
| `Navigator.push` / `Navigator.pop` | Home: `await Navigator.push<bool>(…)`; details: `Navigator.pop(context, _visited)` (also via system back with `PopScope`) |
| `setState`, visited state after going back | Home keeps `Set<int> _visitedIds`; `setState` adds or removes the id |
| Visited is visible (✅ / stamp) | `RouteStopTile` (stamp + green trail + check), `BandCard` (tower + progress) |

## Folder structure

```
lib/
  main.dart                     MaterialApp, theme, SoundService.instance.init()
  data/
    places.dart                 the 4 stops (texts from Figma)
    app_strings.dart            AppStrings.appName = 'The Fifth Musician', tagline, author
  models/
    place.dart                  Place + PlaceFacts
    animal.dart                 the 4 musicians: emoji, colours, call, instrument, voice, haptic
    app_sound.dart              AppSound enum (= Figma "Sound" variables)
  services/
    sound_service.dart          plays all sounds (audioplayers), mute switch
  theme/
    app_colors.dart             AppColors   (Figma "Color" variables)
    app_text.dart               AppText     (Figma text styles)
    app_motion.dart             AppMotion   (Figma "Motion" variables)
    app_spacing.dart            AppSpacing, AppRadius (Figma "Dimensions")
    app_shadows.dart            AppShadows  (Elevation/1, Elevation/2)
    app_theme.dart              Material 3 theme built from the tokens
  screens/
    onboarding_screen.dart      3 pages + name
    home_screen.dart            StatefulWidget, ListView.builder, owns the visited set
    place_details_screen.dart   stamp, voice bubble, SnackBar with UNDO
    band_complete_screen.dart   certificate + confetti
    concert_screen.dart         Bremer Loch: coin → band plays
  widgets/                      one public widget per file
    band_card.dart  musician_tower.dart  tower_slot.dart  route_stop_tile.dart
    visited_stamp.dart  voice_bubble.dart  bremer_loch.dart  local_tip_card.dart
    animal_badge.dart  info_chip.dart  sound_toggle.dart  round_icon_button.dart
    deco_note.dart  dashed_line.dart
assets/sounds/                  11 mp3 + SOUNDS.txt
docs/sound_service_lib_only.dart  SoundService without packages (see below)
test/                           widget tests (flows + layout on small and large phones)
```

## Design → code

The design lives in Figma: [Discover Bremen — FLUTTER ASSIGNMENT](https://www.figma.com/design/pQQJCUzJe2lxfHn35z2pEU/Discover-Bremen----FLUTTER-ASSIGNMENT).
The code uses the same names as the design file:

| Figma | Flutter |
|---|---|
| Variables *Color* (e.g. `color/bg/brand`) | `AppColors.brand` … |
| Text styles (Display/Large … Stamp/Small, Voice/Call) | `AppText.displayLarge` … |
| Variables *Motion* (`duration/stamp`, `easing/slam` …) | `AppMotion.stamp`, `AppMotion.slam` … |
| Variables *Dimensions* (spacing 4–48, radius 8–full) | `AppSpacing`, `AppRadius` |
| Effect styles Elevation/1, Elevation/2 | `AppShadows.elevation1/2` |
| Variables *Sound* | `AppSound` enum |
| Top Bar · Sound Toggle | `_TopBar` in `home_screen.dart` · `SoundToggle` |
| Band Card · Band Progress · Play Pill | `BandCard` (+ private `_BandProgress`, `_PlayPill`) |
| Musician Tower · Tower Slot | `MusicianTower` · `TowerSlot` |
| Route Stop (Upcoming / Next / Visited) | `RouteStopTile` + `StopStatus` |
| Animal Badge (M / XL) + Hero | `AnimalBadge(heroTag: …)`, tag `animal-<id>`, 450 ms |
| Place Hero · Chip · Local Tip Card | `place_details_screen.dart` · `InfoChip` · `LocalTipCard` |
| Stamp (Small / Large) | `VisitedStamp(compact: …)` |
| Voice Bubble | `VoiceBubble` |
| Snackbar | `SnackBar` + `SnackBarAction('UNDO')` (theme in `app_theme.dart`) |
| Button (Primary, Visited, OnBrand, Text) | `FilledButton` / `OutlinedButton` / `TextButton` (theme) |
| Icon Button (Surface, Ghost, OnBrand) | `RoundIconButton` |
| Page Dots · Text Field | `_PageDots` · `TextField` in `onboarding_screen.dart` |
| Coin · Bremer Loch | `_Coin` in `concert_screen.dart` · `BremerLoch` |

**Mark as Visited** follows the Flutter Handoff sequence:

| Time | What happens |
|---|---|
| 0 ms | `setState(_visited = true)`: the stamp slams in (scale 1.6 → 1, 450 ms, `easeInOutBack`) |
| 300 ms | `HapticFeedback.heavyImpact()` + `sfx_stamp` |
| 550 ms | `VoiceBubble` pops (`AnimatedScale` 0.6 → 1, `easeOutBack`) + the animal's voice + haptic |
| 700 ms | floating SnackBar "The donkey joined your band", **UNDO** for 4 s |

A note on the stamp angle: Figma counts rotation counter-clockwise, Flutter
clockwise. Figma's "−12°" is therefore `+12°` in Flutter
(`visited_stamp.dart`), which matches the Figma frames.

## Sounds

All 11 sounds in `assets/sounds/` were **synthesized for this project**
(Python with NumPy/SciPy: Karplus-Strong strings, a modal kettledrum,
additive voices, synthetic reverb). They use no third-party samples or
recordings. See `assets/sounds/SOUNDS.txt` for the list.

`lib/services/sound_service.dart` plays them with the `audioplayers` package,
the only extra package:

- three players: effects (low latency), voices and music
- iOS ambient audio session: the silent switch mutes the app
- one `muted` switch for the whole app
- a `bandPlaying` flag for the "Hear your band" pill

Audio errors are caught, so a missing speaker never crashes a screen.

## Submitting only `lib/`

The brief says to upload only the compressed `lib/` folder. The sound version
also needs `pubspec.yaml` (audioplayers) and `assets/sounds/`. Two zips are
ready in `submission/`:

| File | Contains | Use it when |
|---|---|---|
| `submission/lib.zip` | `lib/` with the **package-free** `SoundService` | only `lib/` may be uploaded (as in the brief) |
| `submission/lib_pubspec_assets.zip` | `lib/` (audioplayers version), `pubspec.yaml`, `assets/` | the lecturer allows pubspec + assets |

The package-free version is `docs/sound_service_lib_only.dart`. It has the
same public API, so no screen changes: sounds become the system click, and
haptics, stamp, voice bubbles and tower stay. To switch the project yourself:

1. Copy `docs/sound_service_lib_only.dart` over `lib/services/sound_service.dart`.
2. Remove `audioplayers` and the `assets:` entry from `pubspec.yaml`.
3. Run `flutter pub get` and `flutter analyze`.

Both versions were checked with `flutter analyze` (0 issues) and all tests.
`lib/` uses relative imports only, so it works in a project with any name.

## Before submitting (to do)

- [ ] Rewrite the 4 **short descriptions** and 4 **local tips** in your own
      words. They are marked `// TODO(Mohamad): rewrite in your own words` in
      `lib/data/places.dart`.
- [ ] Check every fact you keep (dates, names) once more.
- [ ] Test once with the sound off: stamp, voice bubble and tower must still
      tell the story.
- [ ] Pick the zip (see above) and upload it with the Google Form before
      **18 Nov 2026, 23:59** (German time).
