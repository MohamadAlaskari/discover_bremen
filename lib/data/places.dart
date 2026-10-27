import '../models/animal.dart';
import '../models/place.dart';

/// The four stops of the walk, in route order (~2 km through the old town).
///
/// All texts are copied from the Figma details frames. Before submitting,
/// check every fact (dates, names) once more.
const places = <Place>[
  Place(
    id: 1,
    animal: Animal.donkey,
    area: 'Marktplatz',
    name: 'Bremen Town Musicians',
    shortName: 'Town Musicians',
    teaser: 'Bronze statue, 1953',
    // TODO(Mohamad): rewrite in your own words
    description:
        'The four fairy-tale animals, standing on each other’s backs — '
        'Bremen’s most famous photo spot.',
    facts: PlaceFacts(location: 'Marktplatz', price: 'Free', time: '10 min'),
    about:
        'Grimm fairy tale, 1819. Bronze statue by Gerhard Marcks (1953), '
        'right next to the Town Hall — a UNESCO World Heritage Site with the '
        'Roland since 2004.',
    // TODO(Mohamad): rewrite in your own words
    tip:
        'Hold both front legs of the donkey and make a wish — it is said to '
        'bring luck.',
  ),
  Place(
    id: 2,
    animal: Animal.dog,
    area: 'Weser',
    name: 'Schlachte',
    shortName: 'Schlachte',
    teaser: 'Riverside promenade',
    // TODO(Mohamad): rewrite in your own words
    description:
        'Bremen’s old harbour quay on the Weser — now a riverside promenade '
        'with ships and beer gardens.',
    facts: PlaceFacts(location: 'Weser', price: 'Free', time: 'Best at sunset'),
    about:
        'For centuries, ships unloaded their goods here. Today the quay is '
        'lined with restaurants and old ships, and it is lively on summer '
        'evenings.',
    // TODO(Mohamad): rewrite in your own words
    tip:
        'Walk towards the Teerhof bridge, then turn around: the old town '
        'skyline is behind you.',
  ),
  Place(
    id: 3,
    animal: Animal.cat,
    area: 'Altstadt',
    name: 'Schnoor Quarter',
    shortName: 'Schnoor Quarter',
    teaser: 'Bremen’s oldest quarter',
    // TODO(Mohamad): rewrite in your own words
    description:
        'Narrow lanes, tiny colourful houses and small shops in the oldest '
        'part of town.',
    facts: PlaceFacts(location: 'Schnoor', price: 'Free', time: '30 min'),
    about:
        '“Schnoor” means string in Low German: the tiny houses stand in a row '
        'like pearls on a string. Many date from the 15th to the 18th century.',
    // TODO(Mohamad): rewrite in your own words
    tip:
        'Leave the main lane and take the side alleys — that is where it gets '
        'quiet.',
  ),
  Place(
    id: 4,
    animal: Animal.rooster,
    area: 'Domshof',
    name: 'St. Petri Cathedral',
    shortName: 'St. Petri Cathedral',
    teaser: 'Two towers, one view',
    // TODO(Mohamad): rewrite in your own words
    description:
        'Bremen’s cathedral with two towers — climb one for the best view '
        'over the old town.',
    facts: PlaceFacts(
      location: 'Domshof',
      price: 'Tower: fee',
      time: 'Check times',
    ),
    about:
        'Parts of the cathedral date back to the 11th century. Don’t miss the '
        'Bleikeller, a cellar with mummified bodies.',
    // TODO(Mohamad): rewrite in your own words
    tip:
        'Climb the tower on a clear day — you can see the whole route you '
        'walked.',
  ),
];
