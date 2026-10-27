import 'package:flutter/animation.dart';

/// Motion tokens (Figma collection "Motion").
///
/// The Figma prototype uses the same durations and curves, so the app feels
/// like the prototype. The first block is copied 1:1 from the Flutter Handoff.
abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150); // sound toggle, play pill
  static const base = Duration(milliseconds: 300); // snackbar, fades
  static const hero = Duration(milliseconds: 450); // badge flies list → details
  static const stamp = Duration(milliseconds: 450); // visited stamp slams in
  static const stampImpact = Duration(milliseconds: 300); // the stamp lands
  static const voiceDelay = Duration(milliseconds: 250); // stamp lands → voice
  static const slow = Duration(milliseconds: 500); // coin drop, tower rises
  static const stagger = Duration(milliseconds: 400); // next musician joins
  static const pop = Curves.easeOutBack; // voice bubble, tower slot
  static const slam = Curves.easeInOutBack; // visited stamp

  // From the Motion page and the Mark-as-Visited / concert sequences.
  static const standard = Curves.easeInOut; // hero, moves, fades
  static const drop = Curves.easeIn; // coin falls into the slot

  /// Voice bubble (550 ms) → snackbar (700 ms).
  static const snackbarDelay = Duration(milliseconds: 150);

  /// How long the UNDO snackbar stays.
  static const snackbar = Duration(seconds: 4);

  /// Coin tap → the band starts playing.
  static const coinToBand = Duration(milliseconds: 600);
}
