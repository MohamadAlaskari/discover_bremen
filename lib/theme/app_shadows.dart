import 'package:flutter/material.dart';

/// Figma effect styles "Elevation/1" and "Elevation/2".
///
/// The shadows use the ink colour (#2B1D16) at low opacity instead of black,
/// so they stay soft and warm on the cream canvas.
abstract final class AppShadows {
  /// Cards, route stops, unlocked tower slots, voice bubbles.
  static const elevation1 = <BoxShadow>[
    BoxShadow(color: Color(0x0F2B1D16), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x0F2B1D16), offset: Offset(0, 2), blurRadius: 8),
  ];

  /// Things that float above the page: back button, big animal badge, snackbar.
  static const elevation2 = <BoxShadow>[
    BoxShadow(color: Color(0x0F2B1D16), offset: Offset(0, 4), blurRadius: 8),
    BoxShadow(color: Color(0x1F2B1D16), offset: Offset(0, 10), blurRadius: 24),
  ];
}
