import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../models/place_story.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'page_dots.dart';

/// The photos at the top of the Read-more screen (Figma "Photo Slide").
///
/// A PageView with one Image.network per photo. While a photo loads, or
/// when there is no internet, a placeholder in the animal's soft colour
/// shows an image icon and the caption, so the screen always looks complete.
class PhotoCarousel extends StatefulWidget {
  const PhotoCarousel({super.key, required this.photos, required this.animal});

  final List<StoryPhoto> photos;
  final Animal animal;

  /// Fixed height in Figma; the text sheet starts 30 px above its bottom.
  static const height = 360.0;

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  final _pages = PageController();
  int _page = 0;

  /// The dots sit at y = 278 of the photo (Figma), above the sheet's edge.
  static const _dotsTop = 278.0;

  /// The credit's distance from the photo's bottom edge.
  static const _creditBottom = 36.0;

  /// Height of the dark gradient that keeps white text readable.
  static const _scrimHeight = 110.0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PhotoCarousel.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pages,
            itemCount: widget.photos.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) => _slide(widget.photos[index]),
          ),
          Positioned(
            top: _dotsTop,
            left: 0,
            right: 0,
            child: Center(
              child: PageDots(page: _page, count: widget.photos.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slide(StoryPhoto photo) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          photo.url,
          fit: BoxFit.cover,
          semanticLabel: photo.caption,
          // Before the first byte arrives loadingBuilder gets "null" too, so
          // frameBuilder keeps the placeholder until a frame can be shown,
          // then fades the photo in.
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedSwitcher(
              duration: AppMotion.base,
              child: frame == null ? _placeholder(photo) : child,
            );
          },
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : _placeholder(photo),
          errorBuilder: (context, error, stackTrace) => _placeholder(photo),
        ),
        // Dark gradient at the bottom for the white credit and dots.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: _scrimHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.night.withValues(alpha: 0),
                  AppColors.night.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: _creditBottom,
          child: Text(
            photo.credit,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.labelSmall.copyWith(color: AppColors.onNight),
          ),
        ),
      ],
    );
  }

  /// Soft animal colour, image icon and caption (as in the Figma frames,
  /// which show these placeholders where the photos go).
  Widget _placeholder(StoryPhoto photo) {
    return ColoredBox(
      key: const ValueKey('placeholder'),
      color: widget.animal.subtle,
      child: Align(
        // Figma: centred 30 px above the middle, clear of the scrim.
        alignment: const Alignment(0, -1 / 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.xs),
            Text(
              photo.caption,
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
