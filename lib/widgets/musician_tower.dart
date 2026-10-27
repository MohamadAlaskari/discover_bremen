import 'package:flutter/material.dart';

import '../models/animal.dart';
import 'tower_slot.dart';

/// The statue pose: rooster on cat on dog on donkey (Figma "Musician Tower").
/// Each slot unlocks when its stop is marked as visited.
class MusicianTower extends StatelessWidget {
  const MusicianTower({super.key, required this.unlocked, this.scale = 1});

  /// The animals that are already free.
  final Set<Animal> unlocked;

  /// 1 = Home size (166 px high). Other screens show a bigger tower.
  final double scale;

  /// Top to bottom, as in the bronze statue.
  static const _topToBottom = [
    Animal.rooster,
    Animal.cat,
    Animal.dog,
    Animal.donkey,
  ];

  /// The animals stand on each other's backs: slots overlap by 8 px.
  static const _overlap = 8.0;

  @override
  Widget build(BuildContext context) {
    final overlap = _overlap * scale;
    final sizes = [for (final a in _topToBottom) TowerSlot.sizeOf(a) * scale];
    final tops = <double>[];
    var y = 0.0;
    for (final size in sizes) {
      tops.add(y);
      y += size - overlap;
    }
    final width = sizes.last;

    // A Stack instead of a Column: every animal must be painted over the one
    // below it (as in Figma). A Column would paint them the other way round.
    return SizedBox(
      width: width,
      height: y + overlap,
      child: Stack(
        children: [
          for (var i = _topToBottom.length - 1; i >= 0; i--)
            Positioned(
              top: tops[i],
              left: (width - sizes[i]) / 2,
              child: TowerSlot(
                animal: _topToBottom[i],
                unlocked: unlocked.contains(_topToBottom[i]),
                scale: scale,
              ),
            ),
        ],
      ),
    );
  }
}
