// SoundService WITHOUT packages: use it if only the lib/ folder may be
// submitted (Flutter Handoff 53:44, "Code 3").
//
// How to swap it in:
//   1. Copy this file over lib/services/sound_service.dart.
//   2. Remove `audioplayers` from pubspec.yaml (and the assets: entry).
// The public API is the same as the audioplayers version, so no screen
// changes. Every sound becomes the system click; haptics, the stamp, the
// voice bubbles and the tower stay exactly the same.
//
// This file lives outside lib/ on purpose (and is excluded in
// analysis_options.yaml): the import below only works inside lib/services/.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/app_sound.dart';

/// Plays every sound of the app (package-free version).
class SoundService {
  SoundService._();

  static final instance = SoundService._();

  /// Length of band_1 … band_4 (see assets/sounds/SOUNDS.txt).
  static const bandLength = Duration(milliseconds: 11500);

  /// The one mute switch for every sound (speaker icon on Home and Concert).
  final muted = ValueNotifier<bool>(false);

  /// True while the band "plays". Without music files a timer keeps the
  /// "Playing your band…" pill as long as the real song would last.
  final bandPlaying = ValueNotifier<bool>(false);

  Timer? _bandTimer;

  Future<void> init() async {}

  void toggleMute() {
    muted.value = !muted.value;
    if (muted.value) unawaited(stopBand());
  }

  Future<void> play(AppSound sound) async {
    if (!muted.value) await SystemSound.play(SystemSoundType.click);
  }

  Future<void> playBand(int musicians) async {
    if (muted.value || musicians == 0) return;
    await SystemSound.play(SystemSoundType.click);
    bandPlaying.value = true;
    _bandTimer?.cancel();
    _bandTimer = Timer(bandLength, () => bandPlaying.value = false);
  }

  Future<void> stopBand() async {
    _bandTimer?.cancel();
    bandPlaying.value = false;
  }
}
