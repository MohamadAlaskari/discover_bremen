import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'deco_note.dart';

/// Speech bubble with the animal's call (Figma "Voice Bubble").
///
/// It is the visual twin of the animal's voice, so the moment also works
/// with sound off and for deaf users. It pops in with AnimatedScale
/// (0.6 → 1, Curves.easeOutBack) + AnimatedOpacity and grows out of the
/// corner where the tail points at the animal.
class VoiceBubble extends StatelessWidget {
  const VoiceBubble({
    super.key,
    required this.animal,
    required this.visible,
    this.tailOnLeft = false,
    this.size = 1,
  });

  final Animal animal;
  final bool visible;

  /// By default the bubble sits left of the animal, tail bottom right. The
  /// concert puts dog and rooster right of the tower: tail bottom left.
  final bool tailOnLeft;

  /// Overall size factor (e.g. 0.92 on the concert screen, as in Figma).
  final double size;

  static const _border = 2.0;
  static const _tail = Size(18, 12);

  /// Distance of the tail from the bubble's corner.
  static const _tailInset = 16.0;

  @override
  Widget build(BuildContext context) {
    final corner = tailOnLeft ? Alignment.bottomLeft : Alignment.bottomRight;
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: AppMotion.base,
        child: AnimatedScale(
          scale: (visible ? 1 : 0.6) * size,
          alignment: corner,
          duration: AppMotion.base,
          curve: AppMotion.pop,
          child: _bubble(),
        ),
      ),
    );
  }

  Widget _bubble() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: animal.color, width: _border),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.elevation1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                animal.call,
                style: AppText.voiceCall.copyWith(color: animal.color),
              ),
              Text(
                animal.callInEnglish,
                style: AppText.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // The tail points down at the animal.
        Positioned(
          bottom: -_tail.height,
          left: tailOnLeft ? _tailInset : null,
          right: tailOnLeft ? null : _tailInset,
          child: CustomPaint(
            size: _tail,
            painter: _TailPainter(color: animal.color),
          ),
        ),
        // Two little notes fly out of the bubble, away from the animal.
        Positioned(
          top: tailOnLeft ? -14.5 : -18,
          left: tailOnLeft ? null : -10.5,
          right: tailOnLeft ? -10 : null,
          child: DecoNote(
            size: 16,
            color: animal.color,
            angle: tailOnLeft ? 12 : -12,
          ),
        ),
        Positioned(
          top: tailOnLeft ? -5 : -3,
          left: tailOnLeft ? null : -25,
          right: tailOnLeft ? -23 : null,
          child: DecoNote(
            size: 12,
            color: animal.color,
            angle: tailOnLeft ? -10 : 10,
          ),
        ),
      ],
    );
  }
}

/// White wedge with a coloured outline on its two slanted sides. It also
/// covers the bubble's border where the tail joins, so they look like one.
class _TailPainter extends CustomPainter {
  const _TailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const border = VoiceBubble._border;
    final fill = Path()
      ..moveTo(0, -border)
      ..lineTo(size.width, -border)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(fill, Paint()..color = AppColors.surface);

    final outline = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);
    canvas.drawPath(
      outline,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = border
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_TailPainter oldDelegate) => oldDelegate.color != color;
}
