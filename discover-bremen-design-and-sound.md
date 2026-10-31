# Discover Bremen — design & sound decisions (Flutter assignment, due 18 Nov 2026)

Figma: https://www.figma.com/design/pQQJCUzJe2lxfHn35z2pEU (pages: Cover, Foundations, Components, Screens, Flutter Handoff)

## Concept
"The Fifth Musician": 4 stops, one Town Musician per stop. Donkey → Town Musicians statue (Marktplatz), Dog → Schlachte, Cat → Schnoor, Rooster → St. Petri Dom. Mark as Visited frees the animal; the Musician Tower fills up; after 4 stops: Band complete → Bremer Loch concert.

## Sound (added 27 Oct 2026)
- Each animal plays the instrument it gets in the Grimm tale (KHM 27): donkey = lute ("Ich spiele die Laute und du schlägst die Pauke"), dog = kettledrums, cat = night music ("versteht sich auf die Nachtmusik"), rooster = a good voice.
- The band song (G major, 96 BPM, G–C–D–G) gains one instrument per visited stop: band_1 … band_4.
- Files (assets/sounds/, MP3, synthesized for this project, no third-party samples): sfx_stamp, sfx_coin, sfx_undo, voice_donkey/dog/cat/rooster, band_1–4.
- Mark as Visited timeline: 0 ms stamp starts → 300 ms stamp lands (heavyImpact + sfx_stamp) → 550 ms voice bubble + voice_<animal> → 700 ms SnackBar "… joined your band · UNDO" (4 s).
- Bremer Loch (real donation box next to the Bürgerschaft on the Marktplatz; coin → one of the four musicians sounds): coin → sfx_coin → band_4, musicians join every 400 ms.
- Every sound has a visual twin (voice bubble, stamp, tower) → works muted.
- Open: the brief allows only lib/ in the upload. Mohamad will ask the lecturer whether pubspec.yaml + assets/sounds may be submitted. Fallback: package-free SoundService (SystemSound.click + haptics), same API.

## Read more screen (added 29 Oct 2026)
- Each details screen has a "Read more" link → PlaceStoryScreen: photo carousel fixed at the top (PageView, 360 px), text sheet that slides up over it (DraggableScrollableSheet), sections About · The story · Local tradition · Location & visit · Nearby sights · Photo credits. Idea taken from ChatGPT's place sheets.
- Figma: section "08 · Read more — place story" (8 frames: 4 places × sheet down / sheet up), prototype wired from the details screens.
- Photos: Unsplash (Unsplash License, free to use; credits shown anyway), loaded with Image.network → works with a lib-only upload. Wikimedia Commons could not be checked for licences from the work environment, and photos copied from ChatGPT answers have no licence, so they were not used.
- Content: docs/place_stories.json (texts checked against bremen.eu, Wikipedia, stpetridom.de, dommuseum-bremen.de; distances computed from Wikipedia coordinates). Local traditions: donkey's front legs (both hands), Schlachte-Zauber winter market, Katzengang + Bonbon Manufaktur in the Schnoor, cathedral-steps sweeping on the 30th birthday.

## Flutter notes
- Package: audioplayers (AssetSource('sounds/x.mp3'), PlayerMode.lowLatency for effects, iOS ambient audio context).
- New files: models/app_sound.dart, services/sound_service.dart, theme/app_motion.dart, screens/concert_screen.dart, widgets/voice_bubble.dart, widgets/bremer_loch.dart; Read more: models/place_story.dart, data/place_stories.dart, screens/place_story_screen.dart, widgets/photo_carousel.dart, info_row.dart, nearby_card.dart.
- Motion tokens: fast 150, base 300, hero 450, stamp 450, slow 500, stagger 400 ms; curves easeOutBack (pop), easeInOutBack (stamp).

## Before submitting
Rewrite the local tips, descriptions and Read-more texts in own words; look at the 12 photos once and swap any you don't like; re-check facts; test with sound off and offline; remove the debug banner.
