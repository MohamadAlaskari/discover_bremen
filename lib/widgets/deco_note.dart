import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A small tilted music note (Icons.music_note) used as decoration on the
/// onboarding, the details hero and the voice bubbles.
class DecoNote extends StatelessWidget {
  const DecoNote({
    super.key,
    required this.size,
    required this.color,
    this.angle = 0,
  });

  final double size;
  final Color color;

  /// Tilt in degrees, clockwise (the same sign as the Figma code export).
  final double angle;

  @override
  Widget build(BuildContext context) {
    // Pure decoration, so screen readers skip it.
    return ExcludeSemantics(
      child: Transform.rotate(
        angle: angle * math.pi / 180,
        child: Icon(Icons.music_note, size: size, color: color),
      ),
    );
  }
}
