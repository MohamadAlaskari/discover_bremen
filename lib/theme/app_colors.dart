import 'package:flutter/material.dart';

/// Colour tokens from the Figma variables (collection "Color").
///
/// Widgets never use raw hex values, only these names. That way the code
/// reads like the design file and a colour changes in one place.
abstract final class AppColors {
  // Copied 1:1 from Flutter Handoff → "Tokens → Dart".
  static const brand = Color(0xFFC8232C);
  static const brandPressed = Color(0xFF9E1B22);
  static const canvas = Color(0xFFFBF6EC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF4EADB);
  static const textPrimary = Color(0xFF2B1D16);
  static const textSecondary = Color(0xFF6B5A4E);
  static const border = Color(0xFFE8DCCB);
  static const success = Color(0xFF24683F);
  static const successSubtle = Color(0xFFE3F2E8);
  static const note = Color(0xFFF7EED9);
  // concert + snackbar
  static const night = Color(0xFF2B1D16);
  static const onNight = Color(0xFFFBF6EC);
  static const inverseAction = Color(0xFFF08A86);
  static const bronze = Color(0xFF9C7646);
  static const bronzeLight = Color(0xFFC9A877);
  static const bronzeDark = Color(0xFF5B4128);
  static const coin = Color(0xFFC99A2E);

  // Further Figma variables that single components need.

  /// bg/brand-subtle: ring around the "Next" marker.
  static const brandSubtle = Color(0xFFFBE9EA);

  /// border/strong: dashed route trail, upcoming marker.
  static const borderStrong = Color(0xFFB9AA9B);

  /// icon/note: lightbulb on the local tip card.
  static const iconNote = Color(0xFF7C5C10);

  /// coin/edge: rim and € of the coin.
  static const coinEdge = Color(0xFF7C5C10);

  // White on brand red and on the night background. Figma has one variable
  // per role (bg/on-brand-subtle, text/on-brand-faded, …); they all use
  // one of these five opacities.

  /// 15 %: pills, locked slots, cards on the night background.
  static const onBrandSubtle = Color(0x26FFFFFF);

  /// 35 %: empty progress segments, page dots, music notes.
  static const onBrandMuted = Color(0x59FFFFFF);

  /// 50 %: dashed borders, locked animals, deco circles.
  static const onBrandFaded = Color(0x80FFFFFF);

  /// 75 %: small labels on red / night, stamp backing.
  static const onBrandSoft = Color(0xBFFFFFFF);

  /// 90 %: body text on red.
  static const onBrandText = Color(0xE5FFFFFF);

  // Animals (group animal/): strong colour + subtle background.
  static const donkey = Color(0xFF6A5B4E);
  static const donkeySubtle = Color(0xFFEFE9E3);
  static const dog = Color(0xFF2F6F8F);
  static const dogSubtle = Color(0xFFE2EEF3);
  static const cat = Color(0xFFA84A33);
  static const catSubtle = Color(0xFFF6E5DF);
  static const rooster = Color(0xFF7C5C10);
  static const roosterSubtle = Color(0xFFF7EED9);
}
