import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/app_sound.dart';

/// Plays every sound of the app with the audioplayers package.
///
/// Screens only talk to this class, so they never touch audioplayers. Audio
/// errors never reach the UI: every sound has a visual twin (stamp, voice
/// bubble, tower), so the app works without sound too.
class SoundService {
  SoundService._();

  static final instance = SoundService._();

  /// Length of band_1 … band_4 (see assets/sounds/SOUNDS.txt).
  static const bandLength = Duration(milliseconds: 11500);

  /// The one mute switch for every sound (speaker icon on Home and Concert).
  final muted = ValueNotifier<bool>(false);

  /// True while a band song plays. The "Hear your band" pill listens to it.
  final bandPlaying = ValueNotifier<bool>(false);

  // Three players: a voice never cuts off the stamp, music runs on its own.
  // They are created in init(), so widget tests (no audio plugin) never touch
  // the platform: the players simply stay null there.
  AudioPlayer? _effects;
  AudioPlayer? _voice;
  AudioPlayer? _music;

  /// Called once in main() before the app starts.
  Future<void> init() async {
    try {
      _effects = AudioPlayer();
      _voice = AudioPlayer();
      _music = AudioPlayer();
      await _effects!.setPlayerMode(PlayerMode.lowLatency);
      // iOS: the silent switch mutes the app, other music keeps playing.
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
        ),
      );
      // Load all files up front, so the first stamp is not late.
      await AudioCache.instance.loadAll(
        AppSound.values.map((s) => 'sounds/${s.file}').toList(),
      );
      _music!.onPlayerStateChanged.listen(
        (state) => bandPlaying.value = state == PlayerState.playing,
      );
    } catch (error) {
      debugPrint('SoundService: audio is not available ($error)');
    }
  }

  void toggleMute() {
    muted.value = !muted.value;
    if (muted.value) unawaited(stopBand());
  }

  Future<void> play(AppSound sound) async {
    if (muted.value) return;
    final player = sound.isEffect ? _effects : _voice;
    await _safely(() => player?.play(AssetSource('sounds/${sound.file}')));
  }

  /// band_1 … band_4: one instrument per musician in the band.
  Future<void> playBand(int musicians) async {
    if (muted.value || musicians == 0) return;
    final file = 'sounds/band_${musicians.clamp(1, 4)}.mp3';
    await _safely(() => _music?.play(AssetSource(file)));
  }

  Future<void> stopBand() async {
    bandPlaying.value = false;
    await _safely(() => _music?.stop());
  }

  /// A missing speaker or a browser that blocks audio must never crash a
  /// screen, so every player call goes through here.
  Future<void> _safely(Future<void>? Function() action) async {
    try {
      await action();
    } catch (error) {
      debugPrint('SoundService: $error');
    }
  }
}
