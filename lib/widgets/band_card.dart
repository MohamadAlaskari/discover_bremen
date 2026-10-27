import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../services/sound_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'musician_tower.dart';

/// Home header (Figma "Band Card"): how many musicians are free, a progress
/// bar, the Musician Tower and "Hear your band".
class BandCard extends StatelessWidget {
  const BandCard({super.key, required this.freed, this.latest, this.onTap});

  /// The animals that are already free (one per visited stop).
  final Set<Animal> freed;

  /// The animal that joined last, for the caption.
  final Animal? latest;

  /// Set once the band is complete: the whole card opens "Band complete".
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final count = freed.length;
    final total = Animal.values.length;
    final complete = count == total;
    final newest = latest ?? (freed.isEmpty ? null : freed.last);
    final caption = switch (count) {
      0 => 'Visit a stop to free its animal.',
      1 => 'The ${newest!.name} joined your band.',
      2 => 'The ${newest!.name} joined — halfway there.',
      _ when complete => 'You are the fifth musician of Bremen.',
      _ => 'One stop left to complete the band.',
    };

    return Material(
      color: AppColors.brand,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR BAND',
                      style: AppText.overline.copyWith(
                        color: AppColors.onBrandSoft,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      complete
                          ? 'Band complete!'
                          : '$count of $total musicians',
                      style: AppText.headlineMedium.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _BandProgress(count: count, total: total),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      caption,
                      style: AppText.bodyMedium.copyWith(
                        color: AppColors.onBrandText,
                      ),
                    ),
                    // No music while the band is empty (Figma: listen = false).
                    if (count > 0) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      _PlayPill(
                        musicians: count,
                        label: complete
                            ? 'Hear the full band'
                            : 'Hear your band',
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              MusicianTower(unlocked: freed),
            ],
          ),
        ),
      ),
    );
  }
}

/// Four segments, one per stop (Figma "Band Progress").
class _BandProgress extends StatelessWidget {
  const _BandProgress({required this.count, required this.total});

  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        children: [
          for (var i = 0; i < total; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: AnimatedContainer(
                duration: AppMotion.base,
                height: 6,
                decoration: BoxDecoration(
                  color: i < count ? AppColors.surface : AppColors.onBrandMuted,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Hear your band" (Figma "Play Pill"): plays band_n with n = musicians.
/// While the song plays it shows "Playing your band…"; tap again to stop.
class _PlayPill extends StatelessWidget {
  const _PlayPill({required this.musicians, required this.label});

  final int musicians;
  final String label;

  @override
  Widget build(BuildContext context) {
    final sound = SoundService.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: sound.bandPlaying,
      builder: (context, playing, _) => AnimatedSize(
        duration: AppMotion.fast,
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () {
            if (playing) {
              sound.stopBand();
            } else {
              _play(context);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.onBrandSubtle,
            foregroundColor: AppColors.surface,
            minimumSize: const Size(0, 36),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            shape: const StadiumBorder(),
            textStyle: AppText.labelMedium,
            // The pill looks 36 px high but reacts on 48 px (touch target).
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          icon: Icon(playing ? Icons.graphic_eq : Icons.play_arrow),
          label: Text(playing ? 'Playing your band…' : label),
        ),
      ),
    );
  }

  void _play(BuildContext context) {
    final sound = SoundService.instance;
    if (sound.muted.value) {
      // Muted means silent, so explain how to hear the band instead.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Sound is off. Tap the speaker to hear your band.'),
          ),
        );
      return;
    }
    sound.playBand(musicians);
  }
}
