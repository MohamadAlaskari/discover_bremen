import 'animal.dart';

/// One stop on the route: a place in Bremen and the animal it frees.
class Place {
  const Place({
    required this.id,
    required this.animal,
    required this.area,
    required this.name,
    required this.shortName,
    required this.teaser,
    required this.description,
    required this.facts,
    required this.about,
    required this.tip,
  });

  /// 1–4: the stop number on the route. Home keeps a Set of these ids.
  final int id;

  /// The Town Musician that joins the band at this stop.
  final Animal animal;

  /// Part of town for the overline, e.g. "Marktplatz".
  final String area;

  /// Title on the details screen, e.g. "Bremen Town Musicians".
  final String name;

  /// Shorter title in the route list, e.g. "Town Musicians".
  final String shortName;

  /// One line under the title in the route list.
  final String teaser;

  /// Short text under the title on the details screen.
  final String description;

  /// The three fact chips: where, price, time.
  final PlaceFacts facts;

  /// The "About" paragraph.
  final String about;

  /// The "Local tip" card.
  final String tip;

  /// "Stop 1 · Marktplatz" (shown in capitals).
  String get overline => 'Stop $id · $area';

  /// Second line on the big stamp: "Bremen · Stop 1".
  String get stampLine => 'Bremen · Stop $id';

  /// Same tag on the list badge and the details badge, so Flutter's Hero can
  /// fly the badge from one screen to the other.
  String get heroTag => 'animal-$id';
}

/// The three chips on the details screen (icons: place, euro, schedule).
class PlaceFacts {
  const PlaceFacts({
    required this.location,
    required this.price,
    required this.time,
  });

  final String location;
  final String price;
  final String time;
}
