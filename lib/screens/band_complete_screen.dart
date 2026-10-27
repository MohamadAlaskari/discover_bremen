import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/animal.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/animal_badge.dart';
import '../widgets/musician_tower.dart';
import 'concert_screen.dart';

/// The celebration after the fourth stop (Figma "Band complete"): the full
/// statue, a membership certificate with the user's name and the way to the
/// Bremer Loch concert.
///
/// Returns true to Home when the user starts a new journey.
class BandCompleteScreen extends StatelessWidget {
  const BandCompleteScreen({super.key, required this.userName});

  final String userName;

  /// The concert answers with true ("New journey"), false ("Back to my
  /// route") or null (its back arrow: stay here).
  Future<void> _openConcert(BuildContext context) async {
    final newJourney = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ConcertScreen()),
    );
    if (!context.mounted || newJourney == null) return;
    Navigator.pop(context, newJourney);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: LayoutBuilder(
                // Centred on tall phones, scrollable on small ones.
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.md,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      child: _content(context),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned.fill(child: IgnorePointer(child: _Confetti())),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // The bronze statue, now with every animal.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.brand,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: MusicianTower(unlocked: Animal.values.toSet()),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'BAND COMPLETE',
          textAlign: TextAlign.center,
          style: AppText.overline.copyWith(color: AppColors.brand),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'You are the fifth musician!',
          textAlign: TextAlign.center,
          style: AppText.displayLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$userName, you freed all four animals of the Bremen Town Musicians.',
          textAlign: TextAlign.center,
          style: AppText.bodyLarge.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        _Certificate(name: userName),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _openConcert(context),
            icon: const Icon(Icons.euro),
            label: const Text('Drop a coin at the Bremer Loch'),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to my route'),
          ),
        ),
      ],
    );
  }
}

/// "Certificate of membership" with a double red frame.
class _Certificate extends StatelessWidget {
  const _Certificate({required this.name});

  final String name;

  /// Outer and inner corner of the double frame (Figma 20 / 15).
  static const _outerRadius = 20.0;
  static const _innerRadius = 15.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.brand, width: 2),
        borderRadius: BorderRadius.circular(_outerRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.brand),
          borderRadius: BorderRadius.circular(_innerRadius),
        ),
        child: Column(
          children: [
            Text(
              'CERTIFICATE OF MEMBERSHIP',
              textAlign: TextAlign.center,
              style: AppText.overline.copyWith(color: AppColors.brand),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(name, textAlign: TextAlign.center, style: AppText.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              alignment: WrapAlignment.center,
              children: [
                for (final animal in Animal.values) AnimalBadge(animal: animal),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '4 of 4 stops · Bremen ${DateTime.now().year}',
              textAlign: TextAlign.center,
              style: AppText.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Twelve confetti strips that drop in once (positions from Figma).
class _Confetti extends StatefulWidget {
  const _Confetti();

  @override
  State<_Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<_Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  /// Centre (x, y in the 390 px Figma frame), tilt in degrees, colour.
  static const _pieces = <(double, double, double, Color)>[
    (39.7, 75.4, -20, AppColors.brand),
    (91.5, 127.8, 30, AppColors.coin),
    (306.9, 69.7, -35, AppColors.dog),
    (347.6, 147.7, 15, AppColors.success),
    (67.6, 231.8, -50, AppColors.brand),
    (328.2, 257.6, 40, AppColors.coin),
    (154.7, 60.3, -10, AppColors.dog),
    (245.7, 106.5, 60, AppColors.success),
    (31.8, 159.1, -70, AppColors.brand),
    (368.1, 204.8, -25, AppColors.coin),
    (207.4, 42.4, -45, AppColors.dog),
    (120.9, 287.8, 20, AppColors.success),
  ];

  /// How far above its place a strip starts to fall.
  static const _fall = 80.0;

  @override
  void dispose() {
    _drop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Spread the strips over the real width, like on the 390 px frame.
        final scaleX = constraints.maxWidth / 390;
        return AnimatedBuilder(
          animation: _drop,
          builder: (context, _) => Stack(
            children: [
              for (final (index, (x, y, angle, color)) in _pieces.indexed)
                _strip(index, x * scaleX, y, angle, color),
            ],
          ),
        );
      },
    );
  }

  Widget _strip(int index, double x, double y, double angle, Color color) {
    // Each strip starts a little later than the one before.
    final start = index * 0.04;
    final t = Curves.easeOutCubic.transform(
      ((_drop.value - start) / (1 - start)).clamp(0, 1),
    );
    return Positioned(
      left: x - 3.5,
      top: y - 7 - _fall * (1 - t),
      child: Opacity(
        opacity: t,
        child: Transform.rotate(
          angle: (angle + 180 * (1 - t)) * math.pi / 180,
          child: Container(
            width: 7,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
