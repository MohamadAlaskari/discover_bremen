import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_strings.dart';
import '../models/animal.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/dashed_line.dart';
import '../widgets/deco_note.dart';
import '../widgets/info_chip.dart';
import '../widgets/musician_tower.dart';
import '../widgets/page_dots.dart';
import '../widgets/tower_slot.dart';
import 'home_screen.dart';

/// Three story pages on brand red (Figma "Onboarding 1–3"). The last page
/// asks for the user's name, which Home and the certificate show.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pages = PageController();
  final _name = TextEditingController();
  int _page = 0;

  static const _pageCount = 3;

  bool get _isLastPage => _page == _pageCount - 1;

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    super.dispose();
  }

  void _goTo(int page) => _pages.animateToPage(
    page,
    duration: AppMotion.base,
    curve: AppMotion.standard,
  );

  void _next() => _isLastPage ? _start() : _goTo(_page + 1);

  /// The name only lives in memory (no persistence package): Home simply
  /// receives it. pushReplacement makes Home the first page, so "back"
  /// does not lead to the onboarding again.
  void _start() {
    final name = _name.text.trim();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            HomeScreen(userName: name.isEmpty ? AppStrings.defaultName : name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // white status bar icons on red
      child: Scaffold(
        backgroundColor: AppColors.brand,
        body: SafeArea(
          child: Column(
            children: [
              _skipRow(),
              Expanded(
                child: PageView(
                  controller: _pages,
                  onPageChanged: (page) => setState(() => _page = page),
                  children: [
                    const _StoryPage(
                      illustration: _StatueIllustration(),
                      title: 'Four animals set off for Bremen.',
                      body:
                          'A donkey, a dog, a cat and a rooster left home to '
                          'become town musicians — a fairy tale by the '
                          'Brothers Grimm.',
                    ),
                    const _StoryPage(
                      illustration: _WalkingBand(),
                      title: 'They never arrived.',
                      body:
                          'The four found a new home on the way. But Bremen '
                          'kept their story: their statue stands next to the '
                          'Town Hall.',
                    ),
                    _StoryPage(
                      illustration: const _YouOnTop(),
                      title: 'Now you are the fifth musician.',
                      body:
                          'Visit four places in the old town. Every visit '
                          'frees one animal — complete the band!',
                      field: _nameField(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.xxl,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageDots(page: _page, count: _pageCount),
                    const SizedBox(width: AppSpacing.md),
                    Flexible(
                      child: FilledButton.icon(
                        onPressed: _next,
                        iconAlignment: IconAlignment.end,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.brand,
                          iconColor: AppColors.textPrimary,
                        ),
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(_isLastPage ? 'Start my journey' : 'Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// "Skip" jumps to the name page, so the certificate still gets a name.
  Widget _skipRow() {
    return SizedBox(
      height: AppSpacing.xxxl,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: AnimatedOpacity(
            opacity: _isLastPage ? 0 : 1,
            duration: AppMotion.fast,
            child: IgnorePointer(
              ignoring: _isLastPage,
              child: TextButton(
                onPressed: () => _goTo(_pageCount - 1),
                style: TextButton.styleFrom(foregroundColor: AppColors.surface),
                child: const Text('Skip'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Figma "Text Field": TextField + OutlineInputBorder(radius 12),
  /// prefixIcon Icons.person (the look comes from the theme).
  Widget _nameField() {
    return TextField(
      controller: _name,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.givenName],
      // Long names would not fit the top bar and the certificate.
      inputFormatters: [LengthLimitingTextInputFormatter(24)],
      onSubmitted: (_) => _start(),
      style: AppText.bodyLarge.copyWith(color: AppColors.textPrimary),
      decoration: const InputDecoration(
        hintText: 'Your name',
        prefixIcon: Icon(Icons.person, size: 20),
      ),
    );
  }
}

/// One onboarding page: illustration on top, story text, optional field.
class _StoryPage extends StatelessWidget {
  const _StoryPage({
    required this.illustration,
    required this.title,
    required this.body,
    this.field,
  });

  final Widget illustration;
  final String title;
  final String body;
  final Widget? field;

  /// Below this height the illustration is left out (small phone with the
  /// keyboard open) and the text scrolls instead of overflowing.
  static const _minHeightForIllustration = 360.0;

  @override
  Widget build(BuildContext context) {
    final text = Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppText.displayLarge.copyWith(color: AppColors.surface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: AppText.bodyLarge.copyWith(color: AppColors.onBrandText),
          ),
          if (field case final input?) ...[
            const SizedBox(height: AppSpacing.xl),
            input,
          ],
          SizedBox(height: field == null ? AppSpacing.xl : AppSpacing.md),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
        if (keyboardOpen || constraints.maxHeight < _minHeightForIllustration) {
          return SingleChildScrollView(reverse: true, child: text);
        }
        return Column(
          children: [
            // The illustration takes the free space and shrinks on small
            // screens instead of overflowing.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: FittedBox(fit: BoxFit.scaleDown, child: illustration),
              ),
            ),
            text,
          ],
        );
      },
    );
  }
}

/// Page 1: the statue with all four animals, a pedestal and music notes.
class _StatueIllustration extends StatelessWidget {
  const _StatueIllustration();

  /// Figma's tower on this page is 1.5× the Home size.
  static const _scale = 1.5;

  @override
  Widget build(BuildContext context) {
    // A fixed 390 × 343 canvas keeps the notes where Figma puts them;
    // FittedBox in _StoryPage scales the whole canvas on small screens.
    return SizedBox(
      width: 390,
      height: 343,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 40,
            child: Column(
              children: [
                MusicianTower(unlocked: Animal.values.toSet(), scale: _scale),
                Container(
                  width: 150,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.onBrandSubtle,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 67,
            top: 50,
            child: DecoNote(size: 28, color: AppColors.onBrandMuted, angle: 12),
          ),
          const Positioned(
            left: 292,
            top: 15,
            child: DecoNote(
              size: 22,
              color: AppColors.onBrandMuted,
              angle: -10,
            ),
          ),
          const Positioned(
            left: 298,
            top: 229,
            child: DecoNote(size: 30, color: AppColors.onBrandMuted, angle: 6),
          ),
          const Positioned(
            left: 61,
            top: 255,
            child: DecoNote(
              size: 20,
              color: AppColors.onBrandMuted,
              angle: -14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Page 2: the four animals walk to Bremen. They hop one after another.
class _WalkingBand extends StatefulWidget {
  const _WalkingBand();

  @override
  State<_WalkingBand> createState() => _WalkingBandState();
}

class _WalkingBandState extends State<_WalkingBand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _steps = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  /// How high an animal hops, and which part of a step is the hop.
  static const _hop = 6.0;
  static const _hopShare = 0.3;

  @override
  void dispose() {
    _steps.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final (index, animal) in Animal.values.indexed) ...[
              if (index > 0) const SizedBox(width: AppSpacing.sm),
              AnimatedBuilder(
                animation: _steps,
                builder: (context, child) {
                  // Each animal starts its hop a little later than the one
                  // in front of it, so the band looks like it is walking.
                  final phase = (_steps.value - index * 0.15) % 1;
                  final lift = phase < _hopShare
                      ? _hop * math.sin(phase / _hopShare * math.pi)
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(0, -lift),
                    child: child,
                  );
                },
                child: TowerSlot(animal: animal, unlocked: true),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const SizedBox(
          width: 300,
          child: DashedLine(
            color: AppColors.onBrandFaded,
            axis: Axis.horizontal,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const InfoChip(
          icon: Icons.arrow_forward,
          label: 'To Bremen',
          tone: ChipTone.onBrand,
        ),
      ],
    );
  }
}

/// Page 3: "You" on top of the empty tower: the user is the fifth musician.
class _YouOnTop extends StatelessWidget {
  const _YouOnTop();

  static const _towerScale = 1.35;
  static const _you = 52.0;

  /// "You" overlaps the rooster slot a little, like standing on its back.
  static const _overlap = 6.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: _you - _overlap),
          child: MusicianTower(unlocked: {}, scale: _towerScale),
        ),
        Semantics(
          label: 'You',
          child: Container(
            width: _you,
            height: _you,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 28, color: AppColors.brand),
          ),
        ),
      ],
    );
  }
}
