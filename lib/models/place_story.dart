import 'package:flutter/widgets.dart';

import 'animal.dart';

/// Content of the "Read more" screen of one stop.
///
/// Generated from docs/place_stories.json (texts, photo URLs, credits). The
/// JSON also lists the sources of every fact; they stay there for checking.
class PlaceStory {
  const PlaceStory({
    required this.chips,
    required this.about,
    required this.story,
    required this.tradition,
    required this.address,
    required this.price,
    required this.access,
    required this.photos,
    required this.nearby,
  });

  /// The three chips under the name (where, price, time or length).
  final List<StoryChip> chips;
  final String about;
  final String story;

  /// Shown in the "Local tradition" card.
  final String tradition;

  // "Location & visit"
  final String address;
  final String price;
  final String access;

  /// The photos of the carousel at the top.
  final List<StoryPhoto> photos;

  /// Three sights close to this stop.
  final List<NearbySight> nearby;

  /// "Vlad Ion, Hansjörg Keller, …" for the "Photo credits" section.
  /// A photographer with two photos is named once.
  String get photographers => {for (final p in photos) p.author}.join(', ');
}

/// A chip with a Material icon and a short text.
class StoryChip {
  const StoryChip(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// One photo from Unsplash (Unsplash License: free to use; the app still
/// shows the photographer's name on the slide and in the credits).
class StoryPhoto {
  const StoryPhoto({
    required this.url,
    required this.author,
    required this.caption,
  });

  /// Already asks Unsplash for a 1200 px wide JPEG.
  final String url;
  final String author;

  /// Read by screen readers and shown while the photo is missing.
  final String caption;

  String get credit => 'Photo: $author / Unsplash';
}

/// A sight near the stop (Figma "Nearby Card").
class NearbySight {
  const NearbySight({
    required this.name,
    required this.line,
    required this.chip,
    this.icon,
    this.animal,
    this.isCoin = false,
    this.onRoute = false,
  });

  final String name;

  /// One sentence about the sight.
  final String line;

  /// A distance ("≈ 50 m") or route info ("Stop 2 · ≈ 350 m", "Finale").
  final String chip;

  // What the 72 px thumbnail shows: the animal of a route stop, the coin of
  // the Bremer Loch, or a Material icon for any other sight.
  final IconData? icon;
  final Animal? animal;
  final bool isCoin;

  /// Part of the walk (another stop or the finale): the chip is brand red.
  final bool onRoute;
}
