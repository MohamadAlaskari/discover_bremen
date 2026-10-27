import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/animal.dart';
import '../models/app_sound.dart';
import '../services/sound_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/bremer_loch.dart';
import '../widgets/info_chip.dart';
import '../widgets/musician_tower.dart';
import '../widgets/round_icon_button.dart';
import '../widgets/sound_toggle.dart';
import '../widgets/voice_bubble.dart';

/// The Bremer Loch evening concert (Figma "Concert 1–6", night theme).
///
/// Tap the coin → it drops into the slot (sfx_coin + mediumImpact) → after
/// 600 ms band_4 plays, the tower rises out of the Loch and the musicians
/// join one by one with a voice bubble (every 400 ms). The "Now playing"
/// bar runs over the 11.5 s song, also when the sound is muted.
///
/// Returns true ("New journey") or false ("Back to my route").
class ConcertScreen extends StatefulWidget {
  const ConcertScreen({super.key});

  @override
  State<ConcertScreen> createState() => _ConcertScreenState();
}

enum _Phase { idle, dropping, playing }

class _ConcertScreenState extends State<ConcertScreen>
    with SingleTickerProviderStateMixin {
  _Phase _phase = _Phase.idle;

  /// How many musicians already joined (their voice bubbles are visible).
  int _joined = 0;

  /// The buttons appear once the whole band is on stage.
  bool _showActions = false;

  /// Every run gets a number: an older run (before "Play again") stops
  /// as soon as it notices that a newer one started.
  int _run = 0;

  /// The song progress for the "Now playing" bar.
  late final AnimationController _song = AnimationController(
    vsync: this,
    duration: SoundService.bandLength,
  );

  /// The stage in Figma pixels. FittedBox scales it to the screen width.
  static const _stage = Size(390, 444);

  /// Concert tower: 1.9× the Home tower.
  static const _towerScale = 1.9;

  @override
  void dispose() {
    _run++; // stops the steps that are still waiting
    _song.dispose();
    SoundService.instance.stopBand();
    super.dispose();
  }

  Future<void> _dropCoin() async {
    if (_phase != _Phase.idle) return;
    final run = ++_run;
    setState(() => _phase = _Phase.dropping); // coin slides into the slot
    HapticFeedback.mediumImpact();
    SoundService.instance.play(AppSound.coin);
    await Future<void>.delayed(AppMotion.coinToBand);
    if (!mounted || run != _run) return;
    await _playBand(run);
  }

  /// band_4, the tower rises, then one musician every 400 ms.
  Future<void> _playBand(int run) async {
    setState(() {
      _phase = _Phase.playing;
      _joined = 0;
    });
    SoundService.instance.playBand(Animal.values.length);
    _song.forward(from: 0);
    for (var musician = 1; musician <= Animal.values.length; musician++) {
      await Future<void>.delayed(AppMotion.stagger);
      if (!mounted || run != _run) return;
      setState(() => _joined = musician); // donkey, dog, cat, rooster
    }
    await Future<void>.delayed(AppMotion.stagger);
    if (!mounted || run != _run) return;
    setState(() => _showActions = true);
  }

  Future<void> _playAgain() async {
    final run = ++_run;
    await SoundService.instance.stopBand();
    if (!mounted || run != _run) return;
    await _playBand(run);
  }

  @override
  Widget build(BuildContext context) {
    final playing = _phase == _Phase.playing;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.night,
        body: Stack(
          children: [
            _Spotlight(raised: playing),
            SafeArea(
              child: Column(
                children: [
                  _topBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _headline(playing),
                          _stageView(),
                          _footer(playing),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        0,
      ),
      child: Row(
        children: [
          RoundIconButton(
            variant: RoundButtonVariant.onBrand,
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'BREMER LOCH',
                  style: AppText.overline.copyWith(
                    color: AppColors.onBrandSoft,
                  ),
                ),
                Text(
                  'Evening concert',
                  style: AppText.titleMedium.copyWith(
                    color: AppColors.onNight,
                  ),
                ),
              ],
            ),
          ),
          const SoundToggle(variant: RoundButtonVariant.onBrand),
        ],
      ),
    );
  }

  /// Intro text while waiting for the coin, then "Your band is playing!".
  Widget _headline(bool playing) {
    final (key, title, subtitle, gap) = playing
        ? (
            'playing',
            'Your band is playing!',
            'Lute, kettledrums, night music and a good voice.',
            AppSpacing.xxs,
          )
        : (
            'intro',
            'Drop a coin,\nhear your band',
            'Next to the Bürgerschaft on the Marktplatz, a manhole cover is a '
                'real donation box. Drop a coin and one of the four musicians '
                'thanks you.',
            AppSpacing.xs,
          );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.md,
        AppSpacing.xxl,
        AppSpacing.xs,
      ),
      child: AnimatedSize(
        duration: AppMotion.slow,
        curve: AppMotion.standard,
        child: AnimatedSwitcher(
          duration: AppMotion.base,
          child: Column(
            key: ValueKey(key),
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppText.headlineMedium.copyWith(
                  color: AppColors.onNight,
                ),
              ),
              SizedBox(height: gap),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.onBrandSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Coin, Bremer Loch, tower and voice bubbles on a fixed Figma-sized
  /// stage, so every position matches the frames on any phone width.
  Widget _stageView() {
    final idle = _phase == _Phase.idle;
    final playing = _phase == _Phase.playing;
    return AspectRatio(
      aspectRatio: _stage.width / _stage.height,
      child: FittedBox(
        child: SizedBox.fromSize(
          size: _stage,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // The Loch: big while waiting, smaller under the tower.
              AnimatedPositioned(
                duration: AppMotion.slow,
                curve: AppMotion.standard,
                left: playing ? 120 : 85,
                top: playing ? 294 : 178,
                width: playing ? 150 : 220,
                height: playing ? 150 : 220,
                child: BremerLoch(playing: !idle),
              ),
              if (idle)
                const Positioned(
                  left: 153,
                  top: 10,
                  width: 84,
                  height: 84,
                  child: _PulseRing(),
                ),
              // The coin falls into the slot (AppMotion.slow, easeIn) and
              // fades out in the last moment.
              AnimatedPositioned(
                duration: AppMotion.slow,
                curve: AppMotion.drop,
                left: idle ? 167 : 175,
                top: idle ? 24 : 268,
                width: idle ? 56 : 40,
                height: idle ? 56 : 40,
                child: AnimatedOpacity(
                  opacity: idle ? 1 : 0,
                  duration: AppMotion.slow,
                  curve: const Interval(0.7, 1),
                  child: const FittedBox(child: _Coin()),
                ),
              ),
              Positioned(
                top: 102,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: idle ? 1 : 0,
                    duration: AppMotion.base,
                    child: const InfoChip(
                      icon: Icons.touch_app,
                      label: 'Tap the coin',
                      tone: ChipTone.onBrand,
                    ),
                  ),
                ),
              ),
              // Tap area over coin and pulse ring (84 px, bigger than 48).
              if (idle)
                Positioned(
                  left: 153,
                  top: 10,
                  width: 84,
                  height: 84,
                  child: Semantics(
                    button: true,
                    label: 'Coin. Drop it into the Bremer Loch',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _dropCoin,
                    ),
                  ),
                ),
              // The tower rises out of the Loch (AppMotion.slow, pop).
              Positioned(
                left: 142,
                top: 74,
                child: AnimatedOpacity(
                  opacity: playing ? 1 : 0,
                  duration: AppMotion.base,
                  child: AnimatedScale(
                    scale: playing ? 1 : 0.3,
                    alignment: Alignment.bottomCenter,
                    duration: AppMotion.slow,
                    curve: AppMotion.pop,
                    child: MusicianTower(
                      unlocked: Animal.values.toSet(),
                      scale: _towerScale,
                    ),
                  ),
                ),
              ),
              // One bubble per musician, in the order they join. Donkey and
              // cat stand left of the tower, dog and rooster right of it.
              Positioned(
                right: 250,
                bottom: 114,
                child: _bubble(Animal.donkey, 1),
              ),
              Positioned(
                left: 252,
                bottom: 199,
                child: _bubble(Animal.dog, 2, tailOnLeft: true),
              ),
              Positioned(
                right: 248,
                bottom: 273,
                child: _bubble(Animal.cat, 3),
              ),
              Positioned(
                left: 240,
                bottom: 338,
                child: _bubble(Animal.rooster, 4, tailOnLeft: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bubble(Animal animal, int order, {bool tailOnLeft = false}) {
    return VoiceBubble(
      animal: animal,
      visible: _joined >= order,
      tailOnLeft: tailOnLeft,
      size: 0.92,
    );
  }

  /// "Now playing" card, then the three buttons once the band is complete.
  Widget _footer(bool playing) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: AnimatedSize(
        duration: AppMotion.base,
        curve: AppMotion.standard,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            if (playing) _NowPlaying(song: _song),
            AnimatedSwitcher(
              duration: AppMotion.base,
              child: _showActions ? _actions() : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions() {
    final onNight = TextButton.styleFrom(foregroundColor: AppColors.surface);
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to my route'),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.xs,
          children: [
            TextButton.icon(
              onPressed: _playAgain,
              style: onNight,
              icon: const Icon(Icons.refresh),
              label: const Text('Play again'),
            ),
            TextButton.icon(
              // Clears the visited stops on Home (via Band complete).
              onPressed: () => Navigator.pop(context, true),
              style: onNight,
              icon: const Icon(Icons.directions_walk),
              label: const Text('New journey'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Warm golden glow behind the stage; it moves up when the tower rises.
class _Spotlight extends StatelessWidget {
  const _Spotlight({required this.raised});

  final bool raised;

  /// Figma: a 460 px gold circle at 25 % with a strong blur (box 640).
  static const _size = 640.0;
  static const _glow = Color(0x40C99A2E);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: AppMotion.slow,
                curve: AppMotion.standard,
                left: (constraints.maxWidth - _size) / 2,
                // Centre at 57 % of the height, 49 % while the band plays.
                top: constraints.maxHeight * (raised ? 0.49 : 0.57) - _size / 2,
                width: _size,
                height: _size,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [_glow, _glow, Color(0x00C99A2E)],
                      stops: [0, 0.44, 1],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A ring around the coin that keeps "breathing" to invite a tap.
class _PulseRing extends StatefulWidget {
  const _PulseRing();

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) => Transform.scale(
        scale: 1 + 0.2 * _pulse.value,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.coin.withValues(alpha: 0.5 * (1 - _pulse.value)),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

/// The euro coin (Figma "Coin", 56 px): rim, gold face, ring, € and shine.
class _Coin extends StatelessWidget {
  const _Coin();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 56,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.coinEdge,
              ),
            ),
          ),
          Positioned.fill(
            left: 3,
            top: 3,
            right: 3,
            bottom: 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.coin,
              ),
            ),
          ),
          Positioned.fill(
            left: 8,
            top: 8,
            right: 8,
            bottom: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.coinEdge, width: 1.5),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              '€',
              style: TextStyle(
                fontSize: 24,
                height: 1,
                fontWeight: FontWeight.w900,
                color: AppColors.coinEdge,
              ),
            ),
          ),
          // Light reflection on the top left.
          Positioned(
            left: 10,
            top: 10,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(20 / 360),
              child: SizedBox(
                width: 16,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.onBrandFaded,
                    borderRadius: BorderRadius.all(Radius.elliptical(8, 4)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Now playing: The Band of Bremen" with time and a progress bar.
class _NowPlaying extends StatelessWidget {
  const _NowPlaying({required this.song});

  final Animation<double> song;

  static String _clock(Duration time) =>
      '${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    const total = SoundService.bandLength;
    return Semantics(
      label: 'Now playing: The Band of Bremen',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.onBrandSubtle,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: AnimatedBuilder(
          animation: song,
          builder: (context, _) => Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.graphic_eq, color: AppColors.coin),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NOW PLAYING',
                          style: AppText.overline.copyWith(
                            color: AppColors.onBrandSoft,
                          ),
                        ),
                        Text(
                          'The Band of Bremen',
                          style: AppText.titleMedium.copyWith(
                            color: AppColors.onNight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_clock(total * song.value)} / ${_clock(total)}',
                    style: AppText.labelMedium.copyWith(
                      color: AppColors.onBrandSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              // Drawn by hand: the Material progress bar has a different
              // (gap + dot) look in newer Flutter versions.
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onBrandSubtle,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: song.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.coin,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
