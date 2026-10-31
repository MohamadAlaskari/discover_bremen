# Discover Bremen — The Fifth Musician

A Flutter app for the BIP course *Mobile Programming and Technologies*
(HSB Bremen) by Mohamad Alaskari, 2026.

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

Needs **Flutter 3.38 or newer** (built and tested with Flutter 3.47.7 /
Dart 3.13). The UNDO snackbar uses `SnackBar(persist: false)`, which came
with Flutter 3.38.

The zip holds `lib/`, `pubspec.yaml`, `assets/` and this README. To run it:

1. `flutter create discover_bremen`
2. Replace the new project's `lib/` and `pubspec.yaml` with the ones from
   the zip and copy `assets/` into the project folder.
3. Delete `test/widget_test.dart` (the counter test from the template).
4. In the project folder:

```bash
flutter pub get
dart run flutter_launcher_icons   # app icon from Figma (optional)
flutter run -d chrome             # or an Android emulator / phone
```

In Chrome you can also drag with the mouse: swipe the onboarding pages and
the photos, and pull the story sheet up.

The photos on the Read-more screens come from the internet; without a
connection the app shows a placeholder with the photo's caption instead.

## What to try

1. **Onboarding:** three story pages. Enter your name on the last one.
2. **Home:** the route with 4 stops in a `ListView.builder`. Tap a stop.
3. **Details:** tap **Mark as Visited**. The stamp slams in, a voice bubble
   pops up and a snackbar offers **UNDO**. Then tap **Back to your route**.
   The stop now shows the stamp, a green trail and ✅, and the animal stands
   in the Musician Tower.
4. **Read more:** on a details screen, tap **Read more** next to *About*.
   Swipe the three photos, then pull the text sheet up over the photo (or
   tap its grip). The back arrow returns to the details screen; reading does
   not change the visited state.
5. **Hear your band:** plays the band song with one instrument per freed animal.
6. After 4 stops: **Band complete** (certificate with your name) →
   **Drop a coin at the Bremer Loch** → tap the coin → concert.
   **New journey** starts again with 0 stops.

The speaker icon mutes every sound. Every sound has a visual twin (stamp,
voice bubble, tower), so the app is fully usable with the sound off.

## How the assignment is covered

| Requirement | Where |
|---|---|
| List of ≥ 3 places (`ListView.builder`) | `lib/screens/home_screen.dart`, one `RouteStopTile` per stop |
| Details: name, short description, icon/image, Mark as Visited | `lib/screens/place_details_screen.dart` |
| Icons and images | animal badges, Material icons, three photos per place on the Read-more screen |
| `Navigator.push` / `Navigator.pop` | Home: `await Navigator.push<bool>(…)`; details: `Navigator.pop(context, _visited)` (also via system back with `PopScope`) |
| `setState`, visited state after going back | Home keeps `Set<int> _visitedIds`; `setState` adds or removes the id |
| Visited is visible (✅ / stamp) | `RouteStopTile` (stamp + green trail + check), `BandCard` (tower + progress) |

## Folder structure

```
lib/
  main.dart                     MaterialApp, theme, SoundService.instance.init()
  data/
    places.dart                 the 4 stops (names and About texts from Figma)
    place_stories.dart          Read-more content: one PlaceStory constant per stop
    app_strings.dart            AppStrings.appName = 'The Fifth Musician', tagline, author
  models/
    place.dart                  Place (holds its PlaceStory) + PlaceFacts
    place_story.dart            PlaceStory, StoryChip, StoryPhoto, NearbySight
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
    app_scroll_behavior.dart    AppScrollBehavior: mouse drags scroll too (Chrome)
  screens/
    onboarding_screen.dart      3 pages + name
    home_screen.dart            StatefulWidget, ListView.builder, owns the visited set
    place_details_screen.dart   stamp, voice bubble, SnackBar with UNDO, Read more link
    place_story_screen.dart     Read more: fixed photos + text sheet that slides up
    band_complete_screen.dart   certificate + confetti
    concert_screen.dart         Bremer Loch: coin → band plays
  widgets/                      one public widget per file
    band_card.dart  musician_tower.dart  tower_slot.dart  route_stop_tile.dart
    visited_stamp.dart  voice_bubble.dart  bremer_loch.dart  local_tip_card.dart
    animal_badge.dart  info_chip.dart  sound_toggle.dart  round_icon_button.dart
    deco_note.dart  dashed_line.dart  page_dots.dart  coin.dart
    photo_carousel.dart  info_row.dart  nearby_card.dart
assets/sounds/                  11 mp3 + SOUNDS.txt
assets/icon/                    launcher icon from Figma: full, background, foreground (1024 px)
docs/
  place_stories.json            Read-more texts, photo URLs, credits, sources (input, not compiled)
tool/
  make_submission.ps1           builds submission/lib_pubspec_assets.zip
test/
  app_test.dart                 flows + layout on small and large phones
  place_story_test.dart         Read more: every story, swipe, sheet, sections, offline
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
| Page Dots · Text Field | `PageDots` (onboarding and photos) · `TextField` in `onboarding_screen.dart` |
| Coin · Bremer Loch | `Coin` · `BremerLoch` |
| Text Link ("Read more") | `TextButton.icon` in the About header of `place_details_screen.dart` |
| Photo Slide | `PhotoCarousel` (`PageView.builder` + `Image.network`) |
| Read-more sheet | `DraggableScrollableSheet` in `place_story_screen.dart` |
| Info Row · Nearby Card | `InfoRow` · `NearbyCard` |
| Local tradition | `LocalTipCard(title: 'Local tradition')` |

**Mark as Visited** follows the timing from the Figma prototype:

| Time | What happens |
|---|---|
| 0 ms | `setState(_visited = true)`: the stamp slams in (scale 1.6 → 1, 450 ms, `easeInOutBack`) |
| 300 ms | `HapticFeedback.heavyImpact()` + `sfx_stamp` |
| 550 ms | `VoiceBubble` pops (`AnimatedScale` 0.6 → 1, `easeOutBack`) + the animal's voice + haptic |
| 700 ms | floating SnackBar "The donkey joined your band", **UNDO** for 4 s |

A note on the stamp angle: Figma counts rotation counter-clockwise, Flutter
clockwise. Figma's "−12°" is therefore `+12°` in Flutter
(`visited_stamp.dart`), which matches the Figma frames.

## Read more (place story)

`PlaceStoryScreen` is a `Stack` with three layers:

1. **Photos** (`PhotoCarousel`, 360 px, fixed at the top): three photos per
   stop in a `PageView.builder`, with the photographer's credit on each slide
   and page dots.
2. **Text sheet** (`DraggableScrollableSheet`, `snap: true`): it starts 30 px
   above the bottom of the photo and slides up to just below the back button.
   Its `ListView` uses the sheet's scroll controller, so one drag first pulls
   the sheet up and then scrolls the text. Tapping the grip opens or closes it.
   Order: title and chips → About → The story → Local tradition →
   Location & visit → Nearby sights → Photo credits.
3. **Back button** above both.

Each `Place` holds its `PlaceStory` as the required field `place.story`, so
the compiler checks that every stop has its Read-more content (no lookup by
id). The facts come from `docs/place_stories.json`, which also lists the
sources; the final wording is in `lib/data/place_stories.dart`.

**Photos:** loaded from `images.unsplash.com` with `Image.network`, so they
need no assets and no extra package. Unsplash License: free to use, credit
not required; the app shows the credits anyway, on each slide and under
*Photo credits*. While a photo loads, or without internet, a placeholder in
the animal's colour shows an image icon and the caption, so the screen
always looks complete.

## Sounds

All 11 sounds in `assets/sounds/` were **synthesized for this project**
(Python with NumPy/SciPy: Karplus-Strong strings, a modal kettledrum,
additive voices, synthetic reverb). They use no third-party samples or
recordings. See `assets/sounds/SOUNDS.txt` for the list.

`lib/services/sound_service.dart` plays them with the `audioplayers` package,
the only extra package in the app (`flutter_launcher_icons` is only a build
tool, see below):

- three players: effects (low latency), voices and music
- iOS ambient audio session: the silent switch mutes the app
- one `muted` switch for the whole app
- a `bandPlaying` flag for the "Hear your band" pill

Audio errors are caught, so a missing speaker never crashes a screen.

## App icon

The launcher icon is designed in Figma on the page *App Icon*: the
components `App Icon/Background` (brand red with two soft circles, as in the
place hero) and `App Icon/Foreground` (the donkey `Animal Badge`), both
built from the file's colour variables. They are exported at 1024 px to
`assets/icon/`.

`flutter_launcher_icons` (a dev dependency, configured in `pubspec.yaml`)
turns them into the Android icons (classic and adaptive), the iOS app icon
set and the web icons and favicon:

```bash
dart run flutter_launcher_icons
```

The icon files live in `android/`, `ios/` and `web/`, which are not in the
zip. After `flutter create`, the command above creates them from
`assets/icon/`.
