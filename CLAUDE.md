# Discover Bremen — The Fifth Musician (Flutter assignment)

You are building a complete Flutter app for Mohamad Alaskari (HSB Bremen, BIP "Mobile Programming and Technologies"). The design is finished in Figma and you are already connected to it through the Figma MCP. Your job is to turn that design into clean, working Flutter code in this project, test it, and prepare the submission.

## 1. The assignment (from the brief)
- **Task:** a small "Discover Bremen" app.
  - A list of at least 3 places in Bremen (we have 4).
  - Tapping a place opens a details screen with name, short description, an icon/image and a "Mark as Visited" button.
  - After going back, the list shows that the place was visited (✅ / stamp).
- **Required Flutter APIs:** ListView / ListView.builder, Navigator.push / Navigator.pop, setState. Hint from the brief: "Keep your design simple and clear".
- **Grading:**
  - List 25 %
  - Details & navigation 25 %
  - Mark as Visited 20 %
  - Code organisation 15 %
  - Creativity & visual design 15 %
- **Deadline and submission:** 18 Nov 2026, 23:59 (Warsaw time = German time), via the Google Form https://forms.gle/woiphme4u52H3u6n7.
  - The brief says: upload only the compressed `lib/` folder.
  - Mohamad is asking the lecturer whether `pubspec.yaml` + `assets/sounds/` may be added. Build the sound version, but keep the lib-only fallback ready (see section 5).

## 2. Figma (source of truth)
File: https://www.figma.com/design/pQQJCUzJe2lxfHn35z2pEU/Discover-Bremen----FLUTTER-ASSIGNMENT
(node ids: `19:633` in the MCP = `node-id=19-633` in URLs)

**Read the Flutter Handoff page first.** It already contains the folder structure, the component → widget mapping, the tokens as Dart and the sound code.

| Page | What | Node ids |
|---|---|---|
| Flutter Handoff | rules & flow, lib structure, component → widget table, tokens → Dart, before you submit, Sound setup & SoundService, Mark-as-Visited sequence | 22:24, 22:41, 22:46, 22:93, 22:98, 53:44, 53:53 |
| Foundations | Color, Typography, Spacing & Radius, Elevation, Animals, Design principles, Motion, Sound & Haptics | 17:2, 17:180, 17:243, 17:286, 17:294, 17:322, 40:28, 40:110 |
| Components | all components with descriptions that name the Flutter widget to use | page 9:3 |
| Screens — onboarding | Onboarding 1–3 | 18:8, 18:75, 18:125 |
| Screens — home | Home with 0, 1, 2, 3, 4 places visited | 18:177, 18:304, 18:423, 18:542, 18:740 |
| Screens — details (default / visited) | Town Musicians | 19:633 / 19:720 |
| | Schlachte | 19:803 / 19:881 |
| | Schnoor | 19:961 / 19:1039 |
| | St. Petri Cathedral | 19:1119 / 19:1197 |
| Screens — end | Band complete | 18:666 |
| Screens — Bremer Loch concert | 6 steps | 48:1248, 49:1339, 49:1375, 49:1411, 49:1447, 49:1483 |

Variables: collections **Primitives**, **Color**, **Dimensions**, **Motion**, **Sound**. Variable descriptions name the Dart constant (e.g. "Flutter: AppColors.night").

How to read Figma:
- Use `get_variable_defs`, then `get_design_context` and `get_screenshot` per screen.
- Copy all texts from Figma. Do not invent facts.
- The prototype flows "1 · Full flow", "2 · Route only" and "3 · Bremer Loch concert" show the intended behaviour.

## 3. Concept
"The Fifth Musician":
- **Stops and animals:** 4 stops, one Bremen Town Musician per stop.
  - Donkey 🐴 → Town Musicians statue (Marktplatz)
  - Dog 🐶 → Schlachte (Weser)
  - Cat 🐱 → Schnoor (Altstadt)
  - Rooster 🐓 → St. Petri Cathedral (Domshof)
- **Visiting a stop:** marking a stop as visited frees its animal. The Musician Tower on the home screen fills up (rooster on cat on dog on donkey).
- **Instruments:** each animal plays the instrument it gets in the Grimm tale: donkey = lute, dog = kettledrums, cat = night music, rooster = a good voice. "Hear your band" plays band_n.mp3 with n = musicians in the band.
- **End:** after 4 stops → Band complete (certificate with the user's name) → "Drop a coin at the Bremer Loch" → concert screen: coin drops, the full band plays, the animals join one by one.

## 4. Technical rules
- Flutter stable, Material 3, null safety.
- Only one extra package: `audioplayers`. No images from the internet, no other packages.
- Typography and icons:
  - Font: Roboto (Flutter default).
  - Icons: Material Icons only.
  - Animals: normal emoji 🐴🐶🐱🐓. Figma shows "Noto Emoji" outlines only because Figma cannot render colour emoji.
- Tokens:
  - `AppColors`, `AppMotion` and the text styles exactly as on the Handoff page / in the Figma variables.
  - Spacing 4 · 8 · 12 · 16 · 20 · 24 · 32 · 48, radius 8 · 12 · 16 · 24 · full.
- Structure (from Handoff 22:41):
  - Files:
```
lib/
  main.dart                      MaterialApp, theme, SoundService.instance.init()
  theme/  app_colors.dart  app_text.dart  app_motion.dart
  models/ place.dart  app_sound.dart
  data/   places.dart            the 4 stops (texts from Figma)
  services/ sound_service.dart   audioplayers version
  screens/ onboarding_screen.dart  home_screen.dart  place_details_screen.dart
           band_complete_screen.dart  concert_screen.dart
  widgets/ band_card.dart  musician_tower.dart  route_stop_tile.dart  visited_stamp.dart
           voice_bubble.dart  bremer_loch.dart  local_tip_card.dart  (+ small ones if needed)
assets/sounds/                   11 mp3 + SOUNDS.txt (from discover-bremen-sounds.zip)
```
  - One public widget per file. Private `_Widgets` only when used once.
  - Short English comments that explain *why*: code organisation is 15 % of the grade.
- **App name:** keep it in one constant `AppStrings.appName = 'The Fifth Musician'`, with `AppStrings.tagline = 'Discover Bremen'`. The home header shows "Discover Bremen" as in Figma. Mohamad may still change the name.
- **Name:** the user's name comes from onboarding. Keep it in memory only; there is no persistence package.
- **Release polish:** `debugShowCheckedModeBanner: false`. `flutter analyze` must be clean. Run `dart format .` at the end.

## 5. Behaviour (follow Figma + Handoff exactly)
**Home**
- `HomeScreen` is a StatefulWidget. It holds `Set<int> visitedIds` and the user's name.
- `ListView.builder` shows `RouteStopTile`s with the states Upcoming / Next / Visited. Visited shows the stamp, a green trail and ✅.
- Tap a tile → `final visited = await Navigator.push<bool>(…PlaceDetailsScreen(place, isVisited))`. Then `setState` to add or remove the id.
- When the set reaches 4 → push `BandCompleteScreen`.
- `BandCard`:
  - Progress (n of 4) and `MusicianTower`.
  - Slots unlock with `AnimatedScale` + `Curves.easeOutBack`.
  - "Hear your band" pill: hidden at 0 → `SoundService.instance.playBand(n)`. While playing it shows "Playing your band…"; tap again stops.
- Top bar:
  - Sound toggle `IconButton` (Icons.volume_up / volume_off) bound to `SoundService.instance.muted`.
  - Info `IconButton` → `showAboutDialog` (app name, author, "sounds synthesized for this project").
- Hero: wrap the animal badge in `Hero(tag: 'animal-${place.id}')` in both the list and the details screen (450 ms).

**Details: Mark as Visited sequence (timings from the Motion tokens)**
- 0 ms: `setState(_visited = true)`. The stamp slams in (scale 1.6 → 1, rotate 10° → −12°, 450 ms, `Curves.easeInOutBack`).
- 300 ms: `HapticFeedback.heavyImpact()` + `play(AppSound.stamp)`.
- 550 ms: `VoiceBubble` pops (`AnimatedScale` 0.6 → 1, `easeOutBack`) + `play(place.voice)`.
- 700 ms: floating `SnackBar('The <animal> joined your band', action: UNDO, 4 s)`.
  - UNDO → `selectionClick` + `play(AppSound.undo)` + reset the state.
- After marking: the "Visited today" chip appears and the bottom button changes to "Back to your route".
- `Navigator.pop(context, _visited)`. Guard every `setState` after an await with `if (!mounted) return;`.

**Concert (Bremer Loch)**
- Night theme: `AppColors.night`.
- Tap the coin → it slides into the slot (500 ms, `Curves.easeIn`) + `play(AppSound.coin)` + `mediumImpact`.
- After 600 ms → `playBand(4)`. The tower rises (`easeOutBack`), then one `VoiceBubble` every 400 ms: donkey, dog, cat, rooster.
- "Now playing" card with a progress bar over the 11.5 s song.
- Buttons: Back to my route / Play again / New journey (clears the visited set).

**Sound**
- Copy `AppSound` + `SoundService` from Handoff 53:44.
- Unzip `discover-bremen-sounds.zip` (in this folder or in the parent folder) so that `assets/sounds/*.mp3` exists. Then `flutter pub add audioplayers` and add `assets: - assets/sounds/` to `pubspec.yaml`.
- You may extend `SoundService` (e.g. a `bandPlaying` notifier, `stopBand()`). Keep the public API identical to the package-free fallback.
- Save the package-free fallback from Handoff 53:44 as `docs/sound_service_lib_only.dart`, outside `lib/` so it does not break the build. Explain in the README how to swap it in if only `lib/` may be submitted.

## 6. Content
- Texts (titles, descriptions, chips, About, local tips) come from the Figma details frames.
- The 4 local tips and the short descriptions are placeholders. Mohamad must rewrite them in his own words. Mark each one with `// TODO(Mohamad): rewrite in your own words`.

## 7. How to work
1. Read the Figma file (Handoff first, then Foundations, then the screens). Post a short plan: files and order, max 15 lines. Then implement without waiting.
2. Use git: `git init`, and commit after each step with a clear message.
3. Order: theme → models + data → services → widgets → screens → main. Run `flutter analyze` after each step and fix everything.
4. Run the app (`flutter run -d chrome`, and on an Android emulator if available). Compare every screen with `get_screenshot` from Figma and fix visible differences: spacing, colours, text styles, states.
5. Check the layout at 360×640 and 430×932: no overflow (use SafeArea and scrolling where needed). Add Semantics labels for emoji badges and keep touch targets at 48 px.
6. Write `README.md`: how to run, folder structure, design → code mapping, where the sounds come from, the lib-only swap.
7. At the end, create `submission/lib.zip` with PowerShell `Compress-Archive -Path lib -DestinationPath submission/lib.zip -Force`. Also create `submission/lib_pubspec_assets.zip` with `lib`, `pubspec.yaml` and `assets` (in case the lecturer allows it).
8. Finish with a short summary for Mohamad: what you built, how to test it, and what he still has to do (rewrite the tips, test with sound off, choose the zip).

## 8. Acceptance checklist
- [ ] 4 places in a ListView.builder; tap → details; back → visited state shows (stamp + ✅ + tower slot).
- [ ] Mark as Visited: stamp animation, haptic, stamp sound, voice bubble + animal sound, SnackBar with working UNDO.
- [ ] Hear your band plays band_1…band_4 by count; mute switch silences everything; the app is fully usable with sound off.
- [ ] Band complete after 4 stops → Bremer Loch concert works end to end; New journey resets.
- [ ] Hero animation list → details; no layout overflow on small and large screens.
- [ ] Code: one widget per file, tokens instead of magic numbers, comments, `flutter analyze` with 0 issues.
- [ ] README + both submission zips created.

Environment: Windows, PowerShell, the project path contains spaces. If a build tool fails because of the path, say so and suggest moving the project to `D:\dev\discover_bremen`.
