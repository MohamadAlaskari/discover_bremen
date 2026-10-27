import 'package:flutter/material.dart';

/// Text styles from the Figma typography page (Roboto, the Flutter default).
///
/// Figma gives the line height in px, Flutter wants a factor, so every style
/// uses `height: lineHeight / fontSize`. `leadingDistribution: even` puts the
/// extra space above and below the text like Figma does. Colours are added
/// where a style is used, because the same style appears on cream, red and
/// night backgrounds.
abstract final class AppText {
  /// Big onboarding and "Band complete" titles.
  static const displayLarge = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// Screen titles ("Discover Bremen", place names).
  static const headlineMedium = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const titleLarge = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const titleMedium = TextStyle(
    fontSize: 17,
    height: 24 / 17,
    fontWeight: FontWeight.w600,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const bodyLarge = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// Buttons.
  static const labelLarge = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// Chips and pills.
  static const labelMedium = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const labelSmall = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// Small spaced line above titles. Figma stores the text in normal case and
  /// shows it in capitals, so screens call `.toUpperCase()`.
  static const overline = TextStyle(
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// "VISITED" on the big stamp (details screen).
  static const stampLarge = TextStyle(
    fontSize: 26,
    height: 30 / 26,
    fontWeight: FontWeight.w900,
    letterSpacing: 3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// "VISITED" on the small stamp (route list).
  static const stampSmall = TextStyle(
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.6,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The German animal call in the voice bubble ("I-A!").
  static const voiceCall = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w900,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
