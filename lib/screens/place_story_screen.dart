import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/place_stories.dart';
import '../models/place.dart';
import '../models/place_story.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/info_chip.dart';
import '../widgets/info_row.dart';
import '../widgets/local_tip_card.dart';
import '../widgets/nearby_card.dart';
import '../widgets/photo_carousel.dart';
import '../widgets/round_icon_button.dart';

/// "Read more" about one stop (Figma section "08 · Read more — place story").
///
/// Three layers in a Stack: the photo carousel fixed at the top, a sheet
/// with the text that slides up over the photos, and the back button above
/// both. Reading does not change the visited state, so nothing is returned.
class PlaceStoryScreen extends StatefulWidget {
  const PlaceStoryScreen({super.key, required this.place});

  final Place place;

  @override
  State<PlaceStoryScreen> createState() => _PlaceStoryScreenState();
}

class _PlaceStoryScreenState extends State<PlaceStoryScreen> {
  /// Lets the grip open and close the sheet with a tap.
  final _sheet = DraggableScrollableController();

  /// The sheet starts 30 px above the bottom of the photo …
  static const _photoVisible = PhotoCarousel.height - 30;

  /// … and goes up to just below the back button (8 + 48 + 8 px).
  static const _backButtonArea = 64.0;

  /// Height of the grip area: the 4 px grip plus the 20 px gap under it.
  static const _gripArea = 24.0;

  PlaceStory get _story => placeStories[widget.place.id]!;

  @override
  void dispose() {
    _sheet.dispose();
    super.dispose();
  }

  void _toggleSheet(double min, double max) {
    final isOpen = _sheet.size > (min + max) / 2;
    _sheet.animateTo(
      isOpen ? min : max,
      duration: AppMotion.base,
      curve: AppMotion.standard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // white status bar over the photo
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Sheet sizes are fractions of the screen height (Figma: 844 px).
            final height = constraints.maxHeight;
            final maxSize = (height - topInset - _backButtonArea) / height;
            final minSize = math.min(
              maxSize,
              math.max(0.25, (height - _photoVisible) / height),
            );
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: PhotoCarousel(
                    photos: _story.photos,
                    animal: widget.place.animal,
                  ),
                ),
                DraggableScrollableSheet(
                  controller: _sheet,
                  initialChildSize: minSize,
                  minChildSize: minSize,
                  maxChildSize: maxSize,
                  snap: true,
                  builder: (context, scrollController) => _sheetContent(
                    scrollController,
                    onGripTap: () => _toggleSheet(minSize, maxSize),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.md,
                      top: AppSpacing.xs,
                    ),
                    child: RoundIconButton(
                      variant: RoundButtonVariant.surface,
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Back',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// The text sheet. Its ListView uses the sheet's scroll controller, so one
  /// drag first pulls the sheet up and then scrolls the text.
  Widget _sheetContent(
    ScrollController controller, {
    required VoidCallback onGripTap,
  }) {
    final place = widget.place;
    final story = _story;
    final sections = <Widget>[
      _titleBlock(),
      _section('About', _bodyText(story.about)),
      _section('The story', _bodyText(story.story)),
      LocalTipCard(title: 'Local tradition', tip: story.tradition),
      _section(
        'Location & visit',
        Column(
          children: [
            InfoRow(icon: Icons.place, label: 'Address', value: story.address),
            const SizedBox(height: AppSpacing.xs),
            InfoRow(icon: Icons.euro, label: 'Price', value: story.price),
            const SizedBox(height: AppSpacing.xs),
            InfoRow(icon: Icons.schedule, label: 'Access', value: story.access),
          ],
        ),
      ),
      _section(
        'Nearby sights',
        Column(
          children: [
            for (final (index, sight) in story.nearby.indexed) ...[
              if (index > 0) const SizedBox(height: AppSpacing.xs),
              NearbyCard(sight: sight),
            ],
          ],
        ),
      ),
      _credits(story),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.night.withValues(alpha: 0.18),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: ListView(
        controller: controller,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _grip(onGripTap, place),
          for (final (index, section) in sections.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.lg),
            section,
          ],
        ],
      ),
    );
  }

  /// Tap target over the whole width: tapping it opens or closes the sheet.
  Widget _grip(VoidCallback onTap, Place place) {
    return Semantics(
      button: true,
      label: 'Show more or less of the text about ${place.name}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: _gripArea,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleBlock() {
    final place = widget.place;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          place.overline.toUpperCase(),
          style: AppText.overline.copyWith(color: place.animal.color),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(place.name, style: AppText.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final chip in _story.chips)
              InfoChip(icon: chip.icon, label: chip.label),
          ],
        ),
      ],
    );
  }

  /// A heading with its content, 8 px apart (Figma section blocks).
  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }

  Widget _bodyText(String text) {
    return Text(
      text,
      style: AppText.bodyLarge.copyWith(color: AppColors.textSecondary),
    );
  }

  /// The Unsplash License does not require credits; we show them anyway.
  Widget _credits(PlaceStory story) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PHOTO CREDITS',
          style: AppText.overline.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Photos from Unsplash (Unsplash License): ${story.photographers}.',
          style: AppText.labelSmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
