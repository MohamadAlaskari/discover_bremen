import '../models/animal.dart';
import '../models/place.dart';

/// The four stops of the walk, in route order (~2 km through the old town).
///
/// Names, chips and the About texts come from the Figma details frames. The
/// descriptions and local tips are rewritten in plain English with the same
/// facts.
const places = <Place>[
  Place(
    id: 1,
    animal: Animal.donkey,
    area: 'Marktplatz',
    name: 'Bremen Town Musicians',
    shortName: 'Town Musicians',
    teaser: 'Bronze statue, 1953',
    description:
        'The four fairy-tale animals, standing on each other’s backs. It’s '
        'probably the most famous photo spot in Bremen.',
    facts: PlaceFacts(location: 'Marktplatz', price: 'Free', time: '10 min'),
    about:
        'Grimm fairy tale, 1819. Bronze statue by Gerhard Marcks (1953), '
        'right next to the Town Hall — a UNESCO World Heritage Site with the '
        'Roland since 2004.',
    tip:
        'Hold both of the donkey’s front legs and make a wish. It’s supposed '
        'to bring luck, so don’t be shy.',
  ),
  Place(
    id: 2,
    animal: Animal.dog,
    area: 'Weser',
    name: 'Schlachte',
    shortName: 'Schlachte',
    teaser: 'Riverside promenade',
    description:
        'Bremen’s old harbour quay on the Weser. Now it’s a promenade where '
        'you walk past ships and beer gardens.',
    facts: PlaceFacts(location: 'Weser', price: 'Free', time: 'Best at sunset'),
    about:
        'For centuries, ships unloaded their goods here. Today the quay is '
        'lined with restaurants and old ships, and it is lively on summer '
        'evenings.',
    tip:
        'Walk as far as the Teerhof bridge and then turn around. The old town '
        'skyline is right there behind you.',
  ),
  Place(
    id: 3,
    animal: Animal.cat,
    area: 'Altstadt',
    name: 'Schnoor Quarter',
    shortName: 'Schnoor Quarter',
    teaser: 'Bremen’s oldest quarter',
    description:
        'The oldest part of town, with tiny colourful houses and small shops '
        'squeezed into narrow lanes.',
    facts: PlaceFacts(location: 'Schnoor', price: 'Free', time: '30 min'),
    about:
        '“Schnoor” means string in Low German: the tiny houses stand in a row '
        'like pearls on a string. Many date from the 15th to the 18th century.',
    tip:
        'Leave the main lane and try the side alleys. It gets much quieter '
        'there.',
  ),
  Place(
    id: 4,
    animal: Animal.rooster,
    area: 'Domshof',
    name: 'St. Petri Cathedral',
    shortName: 'St. Petri Cathedral',
    teaser: 'Two towers, one view',
    description:
        'Bremen’s cathedral has two towers, and you can climb one of them. '
        'The view over the old town is worth the stairs.',
    facts: PlaceFacts(
      location: 'Domshof',
      price: 'Tower: fee',
      time: 'Check times',
    ),
    about:
        'Parts of the cathedral date back to the 11th century. Don’t miss the '
        'Bleikeller, a cellar with mummified bodies.',
    tip:
        'Go up the tower on a clear day. From the top you can see the whole '
        'route you just walked.',
  ),
];
