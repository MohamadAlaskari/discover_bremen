import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import 'app_sound.dart';

/// The four Bremen Town Musicians. Every stop of the walk frees one of them.
///
/// Everything that belongs to an animal lives here, so a screen simply asks
/// `place.animal.color` instead of switching over the animal everywhere.
enum Animal {
  donkey(
    emoji: '🐴',
    color: AppColors.donkey,
    subtle: AppColors.donkeySubtle,
    call: 'I-A!',
    callInEnglish: 'hee-haw',
    instrument: 'lute',
    voice: AppSound.donkey,
    haptic: HapticFeedback.heavyImpact,
    hapticCount: 2,
  ),
  dog(
    emoji: '🐶',
    color: AppColors.dog,
    subtle: AppColors.dogSubtle,
    call: 'Wuff!',
    callInEnglish: 'woof',
    instrument: 'kettledrums',
    voice: AppSound.dog,
    haptic: HapticFeedback.mediumImpact,
    hapticCount: 2,
  ),
  cat(
    emoji: '🐱',
    color: AppColors.cat,
    subtle: AppColors.catSubtle,
    call: 'Miau!',
    callInEnglish: 'meow',
    instrument: 'night music',
    voice: AppSound.cat,
    haptic: HapticFeedback.lightImpact,
    hapticCount: 1,
  ),
  rooster(
    emoji: '🐓',
    color: AppColors.rooster,
    subtle: AppColors.roosterSubtle,
    call: 'Kikeriki!',
    callInEnglish: 'cock-a-doodle-doo',
    instrument: 'a good voice',
    voice: AppSound.rooster,
    haptic: HapticFeedback.selectionClick,
    hapticCount: 4,
  );

  const Animal({
    required this.emoji,
    required this.color,
    required this.subtle,
    required this.call,
    required this.callInEnglish,
    required this.instrument,
    required this.voice,
    required this.haptic,
    required this.hapticCount,
  });

  /// Shown as normal colour emoji on the phone (Figma draws outlines only
  /// because it cannot render colour emoji).
  final String emoji;

  /// Strong animal colour: badge ring, voice bubble, overline.
  final Color color;

  /// Light background of the badge and the details hero.
  final Color subtle;

  /// Call in German, because the tale is from Bremen ("I-A!")…
  final String call;

  /// …with the English word under it in the voice bubble.
  final String callInEnglish;

  /// What the animal plays in the Grimm tale (KHM 27).
  final String instrument;

  /// The voice that plays when the animal joins the band.
  final AppSound voice;

  /// The animal's voice you can feel (Figma "Sound & Haptics"), e.g. the
  /// donkey is 2 × heavyImpact and the rooster 4 × selectionClick.
  final Future<void> Function() haptic;
  final int hapticCount;

  /// Pause between two haptic pulses, so they are felt one by one.
  static const _hapticGap = Duration(milliseconds: 120);

  /// "Donkey" instead of "donkey", for screen reader labels.
  String get label => name[0].toUpperCase() + name.substring(1);

  /// Plays the haptic pattern together with the voice.
  Future<void> playHaptic() async {
    for (var i = 0; i < hapticCount; i++) {
      if (i > 0) await Future<void>.delayed(_hapticGap);
      await haptic();
    }
  }
}
