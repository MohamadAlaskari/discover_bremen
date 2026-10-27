import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/places.dart';
import '../models/app_sound.dart';
import '../models/place.dart';
import '../services/sound_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/animal_badge.dart';
import '../widgets/deco_note.dart';
import '../widgets/info_chip.dart';
import '../widgets/local_tip_card.dart';
import '../widgets/round_icon_button.dart';
import '../widgets/visited_stamp.dart';
import '../widgets/voice_bubble.dart';

/// Details of one stop (Figma "Details · Schlachte" etc. and "… · visited").
///
/// "Mark as Visited" runs the sequence from the Flutter Handoff: the stamp
/// slams in, then haptic + stamp sound, then the voice bubble + the animal's
/// voice, then a SnackBar with UNDO. Navigator.pop gives the visited flag
/// back to Home.
class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({
    super.key,
    required this.place,
    required this.isVisited,
  });

  final Place place;

  /// The state when the screen opens (Home's Set contains the id).
  final bool isVisited;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  late bool _visited = widget.isVisited;
  late bool _showVoice = widget.isVisited;

  /// This screen has its own ScaffoldMessenger, so the UNDO snackbar leaves
  /// together with the screen and can never undo anything from Home.
  final _messenger = GlobalKey<ScaffoldMessengerState>();

  /// Figma "Place Hero" height; the sheet overlaps its rounded top.
  static const _heroHeight = 280.0;

  Place get _place => widget.place;

  /// The Mark-as-Visited sequence (timings from the Motion tokens).
  Future<void> _markVisited() async {
    setState(() => _visited = true); // 0 ms: the stamp slams in
    await Future<void>.delayed(AppMotion.stampImpact);
    if (!mounted) return;
    HapticFeedback.heavyImpact(); // 300 ms: the stamp lands
    SoundService.instance.play(AppSound.stamp);

    await Future<void>.delayed(AppMotion.voiceDelay);
    if (!mounted) return;
    setState(() => _showVoice = true); // 550 ms: the animal joins
    SoundService.instance.play(_place.animal.voice);
    _place.animal.playHaptic();

    await Future<void>.delayed(AppMotion.snackbarDelay);
    if (!mounted) return;
    _messenger.currentState // 700 ms: offer UNDO
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: AppMotion.snackbar,
          // A snackbar with an action would stay forever by default.
          persist: false,
          content: Row(
            children: [
              const Icon(
                Icons.music_note,
                size: 20,
                color: AppColors.inverseAction,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('The ${_place.animal.name} joined your band'),
              ),
            ],
          ),
          action: SnackBarAction(label: 'UNDO', onPressed: _undo),
        ),
      );
  }

  void _undo() {
    HapticFeedback.selectionClick();
    SoundService.instance.play(AppSound.undo);
    setState(() {
      _visited = false;
      _showVoice = false;
    });
  }

  /// Back to the list with the result.
  void _close() => Navigator.pop(context, _visited);

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      canPop: false,
      // The system back button / gesture must return the result too.
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ScaffoldMessenger(
          key: _messenger,
          child: Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Stack(
                    children: [
                      _hero(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: _heroHeight - AppRadius.xl,
                        ),
                        child: _sheet(),
                      ),
                    ],
                  ),
                ),
                // Floats over the hero and stays in place while scrolling.
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.md,
                      top: AppSpacing.xs,
                    ),
                    child: RoundIconButton(
                      variant: RoundButtonVariant.surface,
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Back to your route',
                      onPressed: _close,
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _actionBar(),
          ),
        ),
      ),
    );
  }

  /// Figma "Place Hero": animal colour, deco circles and notes, the big
  /// badge (Hero), the stop chip, the voice bubble and the stamp.
  Widget _hero() {
    final animal = _place.animal;
    final noteColor = animal.color.withValues(alpha: 0.3);
    return SizedBox(
      height: _heroHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Everything is placed relative to the middle, so it also fits
          // narrower and wider phones than the 390 px Figma frame.
          final center = constraints.maxWidth / 2;
          return Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(
                  color: animal.subtle,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      const Positioned(
                        left: -80,
                        bottom: -110,
                        child: _DecoCircle(size: 240),
                      ),
                      const Positioned(
                        right: -60,
                        top: -40,
                        child: _DecoCircle(size: 180),
                      ),
                      Positioned(
                        left: center - 141,
                        top: 101.5,
                        child: DecoNote(size: 22, color: noteColor, angle: -12),
                      ),
                      Positioned(
                        left: center + 120.5,
                        top: 178,
                        child: DecoNote(size: 26, color: noteColor, angle: 10),
                      ),
                      Positioned(
                        left: center + 106,
                        top: 90.5,
                        child: DecoNote(size: 18, color: noteColor, angle: -8),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                child: Center(
                  child: InfoChip(
                    icon: Icons.directions_walk,
                    label: 'Stop ${_place.id} of ${places.length}',
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: center - 60,
                child: AnimalBadge(
                  animal: animal,
                  size: 120,
                  lift: 1,
                  heroTag: _place.heroTag,
                ),
              ),
              // Left of the badge; the tail corner touches the badge.
              Positioned(
                right: center + 52,
                bottom: _heroHeight - 168,
                child: VoiceBubble(animal: animal, visible: _showVoice),
              ),
              // The big stamp lands on the right half of the badge.
              Positioned(
                left: center + 11.4,
                top: 118,
                width: 176,
                height: 107.5,
                child: Center(
                  child: VisitedStamp(
                    visible: _visited,
                    subtitle: _place.stampLine,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// The cream sheet with title, facts, About and the local tip.
  Widget _sheet() {
    final place = _place;
    final facts = place.facts;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.overline.toUpperCase(),
            style: AppText.overline.copyWith(color: place.animal.color),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(place.name, style: AppText.headlineMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            place.description,
            style: AppText.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              if (_visited)
                const InfoChip(
                  icon: Icons.check_circle,
                  label: 'Visited today',
                  tone: ChipTone.success,
                ),
              InfoChip(icon: Icons.place, label: facts.location),
              InfoChip(icon: Icons.euro, label: facts.price),
              InfoChip(icon: Icons.schedule, label: facts.time),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('About', style: AppText.titleMedium),
          const SizedBox(height: 6),
          Text(
            place.about,
            style: AppText.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          LocalTipCard(tip: place.tip),
        ],
      ),
    );
  }

  /// Figma "Bottom Action Bar": the one main action of the screen.
  Widget _actionBar() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: AppSpacing.xl),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            0,
          ),
          child: AnimatedSwitcher(
            duration: AppMotion.base,
            child: SizedBox(
              key: ValueKey(_visited),
              width: double.infinity,
              child: _visited
                  // Figma Button "Visited": the success state.
                  ? OutlinedButton.icon(
                      onPressed: _close,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.successSubtle,
                        foregroundColor: AppColors.success,
                        side: const BorderSide(
                          color: AppColors.success,
                          width: 1.5,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to your route'),
                    )
                  : FilledButton.icon(
                      onPressed: _markVisited,
                      icon: const Icon(Icons.check),
                      label: const Text('Mark as Visited'),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft white circle in the hero background.
class _DecoCircle extends StatelessWidget {
  const _DecoCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.onBrandFaded,
      ),
    );
  }
}
