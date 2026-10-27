import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A dashed line: the route trail on Home and the road on the onboarding.
///
/// Flutter has no dashed border, so a tiny CustomPainter draws the dashes.
/// The line fills its parent along [axis] (put it in an Expanded or SizedBox).
class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    required this.color,
    this.axis = Axis.vertical,
    this.thickness = 2,
    this.dash = 5,
    this.gap = 4,
  });

  final Color color;
  final Axis axis;
  final double thickness;
  final double dash;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final vertical = axis == Axis.vertical;
    return SizedBox(
      width: vertical ? thickness : double.infinity,
      height: vertical ? double.infinity : thickness,
      child: CustomPaint(
        painter: _DashPainter(color: color, axis: axis, dash: dash, gap: gap),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter({
    required this.color,
    required this.axis,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final Axis axis;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final vertical = axis == Axis.vertical;
    final paint = Paint()
      ..color = color
      ..strokeWidth = vertical ? size.width : size.height;
    final length = vertical ? size.height : size.width;
    for (var start = 0.0; start < length; start += dash + gap) {
      final end = math.min(start + dash, length);
      if (vertical) {
        final x = size.width / 2;
        canvas.drawLine(Offset(x, start), Offset(x, end), paint);
      } else {
        final y = size.height / 2;
        canvas.drawLine(Offset(start, y), Offset(end, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.axis != axis ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap;
}
