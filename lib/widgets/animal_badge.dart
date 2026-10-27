import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// Round badge with the animal emoji (Figma "Animal Badge", M 48 / XL 120).
///
/// [lift] blends the list look (subtle background) into the details look
/// (white, coloured ring, shadow): 0 = list, 1 = details. With a [heroTag]
/// the badge becomes a Hero and morphs while it flies from the route list to
/// the details screen (and back).
class AnimalBadge extends StatelessWidget {
  const AnimalBadge({
    super.key,
    required this.animal,
    this.size = 48,
    this.lift = 0,
    this.heroTag,
  });

  final Animal animal;
  final double size;
  final double lift;
  final String? heroTag;

  /// Emoji size relative to the badge (26 px in 48, 64 px in 120).
  static const _emojiRatio = 0.54;

  @override
  Widget build(BuildContext context) {
    final badge = Semantics(
      label: animal.label,
      image: true,
      child: SizedBox.square(dimension: size, child: _face(lift)),
    );
    final tag = heroTag;
    if (tag == null) return badge;
    return Hero(
      tag: tag,
      // The flight animation runs 0 → 1 on push and 1 → 0 on pop, so the
      // badge changes its look while it moves.
      flightShuttleBuilder: (_, animation, _, _, _) => AnimatedBuilder(
        animation: animation,
        builder: (context, _) => _face(animation.value),
      ),
      child: badge,
    );
  }

  Widget _face(double t) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Measure the real box: during the Hero flight it changes size every
        // frame and the emoji has to grow with it.
        final dimension = constraints.biggest.shortestSide;
        return DecoratedBox(
          decoration: BoxDecoration.lerp(_listLook, _detailsLook, t)!,
          child: Center(
            child: Text(
              animal.emoji,
              style: TextStyle(
                fontSize: dimension * _emojiRatio,
                height: 1,
                // The Hero flies outside the page's Material: without this,
                // Flutter would draw a yellow debug underline.
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration get _listLook =>
      BoxDecoration(shape: BoxShape.circle, color: animal.subtle);

  BoxDecoration get _detailsLook => BoxDecoration(
    shape: BoxShape.circle,
    color: AppColors.surface,
    border: Border.all(color: animal.color, width: 3),
    boxShadow: AppShadows.elevation2,
  );
}
