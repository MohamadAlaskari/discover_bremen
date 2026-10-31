import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../models/place_story.dart';

// The Read-more content of the four stops: one PlaceStory per stop.
// places.dart gives each Place its story (Place.story), so the compiler
// checks that no stop is missing one.
//
// The facts come from docs/place_stories.json, which lists the sources
// (bremen.eu, Wikipedia, stpetridom.de, …). The wording is rewritten in
// plain English; the facts are the same.
// Photos: Unsplash License, credits on each slide and under the text.

/// Stop 1: Bremen Town Musicians (Marktplatz).
const townMusiciansStory = PlaceStory(
  chips: [
    StoryChip('Marktplatz', Icons.place),
    StoryChip('Free', Icons.euro),
    StoryChip('Open-air, any time', Icons.schedule),
  ],
  about:
      'A bronze statue of the four animals from the Grimm tale, stacked on '
      'top of each other. It’s only about 2 m tall and stands on the west '
      'side of the Town Hall.',
  story:
      'The Brothers Grimm published the tale in 1819. The funny part is that '
      'the animals never reach Bremen. On the way they find a robbers’ house '
      'and just stay there. Gerhard Marcks made the statue. It was put up in '
      '1953, at first only as a one-year trial, and it’s still here.',
  tradition:
      'People hold the donkey’s front legs and make a wish. Take both legs, '
      'though. Locals say that one hand on one leg shows everyone you’re new '
      'in town.',
  address: 'Schoppensteel, west side of the Town Hall, 28195 Bremen',
  price: 'Free',
  access: 'Open-air, any time',
  photos: [
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1765357480892-8707a6ad6a10'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Vlad Ion',
      caption: 'The statue at the Town Hall',
    ),
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1684777775603-5fbb6b835f79'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Hansjörg Keller',
      caption: 'Donkey, dog, cat and rooster',
    ),
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1783614674924-948907f6126c'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Alexandre Valdivia',
      caption: 'Town Hall facade',
    ),
  ],
  nearby: [
    NearbySight(
      name: 'Bremer Rathaus',
      line:
          'Gothic town hall, built from 1405 to 1410. UNESCO World Heritage '
          'since 2004.',
      chip: '≈ 50 m',
      icon: Icons.account_balance,
    ),
    NearbySight(
      name: 'Bremer Roland',
      line: 'A stone knight from 1404. He stands for the city’s freedom.',
      chip: '≈ 50 m',
      icon: Icons.shield,
    ),
    NearbySight(
      name: 'Schlachte',
      line: 'Your next stop: the promenade along the Weser.',
      chip: 'Stop 2 · ≈ 350 m',
      animal: Animal.dog,
      onRoute: true,
    ),
  ],
);

/// Stop 2: Schlachte (Weser).
const schlachteStory = PlaceStory(
  chips: [
    StoryChip('Weser', Icons.place),
    StoryChip('Free', Icons.euro),
    StoryChip('660 m promenade', Icons.directions_walk),
  ],
  about:
      'A 660 m promenade along the Weser, right in the old town. Restaurants '
      'and bars line the quay, with old ships like the Alexander von '
      'Humboldt tied up next to them.',
  story:
      'The name comes from the Low German word slagte, the posts that were '
      'driven into the river bank. From the 13th century on, this was '
      'Bremen’s harbour. In the 19th century the railway and new port '
      'basins took over. Between 1993 and 2000 the quay was rebuilt as a '
      'promenade.',
  tradition:
      'In winter the quay turns into the Schlachte-Zauber market, with about '
      '100 wooden huts and ships covered in lights. It runs from late '
      'November into December.',
  address: 'Schlachte, 28195 Bremen',
  price: 'Free',
  access: 'Open-air, any time',
  photos: [
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1706647899574-f687793c1b2e'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Jahanzeb Ahsan',
      caption: 'Sunset on the Weser',
    ),
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1764505879137-1ec598f6eb17'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Nikolai Kolosov',
      caption: 'Ships along the quay',
    ),
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1733747402311-8ec471f8b12f'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Peter Schulz',
      caption: 'The Schlachte at night',
    ),
  ],
  nearby: [
    NearbySight(
      name: 'St. Martini',
      line: 'A Brick Gothic church by the river, first mentioned in 1229.',
      chip: 'At the Schlachte',
      icon: Icons.church,
    ),
    NearbySight(
      name: 'Böttcherstraße',
      line:
          'Only 108 m long, but full of 1920s brick art. Listen for the '
          'porcelain Glockenspiel.',
      chip: '≈ 250 m',
      icon: Icons.music_note,
    ),
    NearbySight(
      name: 'Schnoor Quarter',
      line: 'Your next stop: old lanes and tiny houses.',
      chip: 'Stop 3 · ≈ 600 m',
      animal: Animal.cat,
      onRoute: true,
    ),
  ],
);

/// Stop 3: Schnoor Quarter (Altstadt).
const schnoorStory = PlaceStory(
  chips: [
    StoryChip('Altstadt', Icons.place),
    StoryChip('Free', Icons.euro),
    StoryChip('Houses from 1401', Icons.schedule),
  ],
  about:
      'Bremen’s oldest quarter, full of narrow lanes, small houses, shops '
      'and cafés. Some lanes are so narrow that you can stretch out your '
      'arms and touch both walls.',
  story:
      'Fishermen, boatmen and craftsmen used to live here by the Balge, an '
      'arm of the Weser. The name Schnoor is Low German for string or cord '
      'and comes from the old ship trades. The oldest house, Schnoor 2, '
      'dates from 1401. Many of the houses were restored from 1955 on.',
  tradition:
      'Go and find the Katzengang, a really narrow lane. Then stop at the '
      'Bremer Bonbon Manufaktur, where you can watch them make sweets by '
      'hand.',
  address: 'Schnoor, 28195 Bremen (tram stop Domsheide)',
  price: 'Free',
  access: 'Open-air, any time. Shops have their own hours.',
  photos: [
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1713627617744-3ecdb533ce8c'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Alain ROUILLER',
      caption: 'Old houses in the Schnoor',
    ),
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1666181528393-74a1af15ec96'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Manou Azadi',
      caption: 'A cobbled lane',
    ),
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1666181526939-2c216bb961df'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Manou Azadi',
      caption: 'One of the narrow alleys',
    ),
  ],
  nearby: [
    NearbySight(
      name: 'St. Johann',
      line:
          'A Catholic Brick Gothic church, built for Franciscan monks in the '
          '14th century.',
      chip: '≈ 150 m',
      icon: Icons.church,
    ),
    NearbySight(
      name: 'Kunsthalle Bremen',
      line:
          'The art museum of the Kunstverein. It has had its own building '
          'since 1849.',
      chip: '≈ 250 m',
      icon: Icons.museum,
    ),
    NearbySight(
      name: 'St. Petri Cathedral',
      line: 'Your next stop: the cathedral with two 93 m towers.',
      chip: 'Stop 4 · ≈ 300 m',
      animal: Animal.rooster,
      onRoute: true,
    ),
  ],
);

/// Stop 4: St. Petri Cathedral (Domshof).
const stPetriStory = PlaceStory(
  chips: [
    StoryChip('Domshof', Icons.place),
    StoryChip('Museum: free', Icons.euro),
    StoryChip('Tower: 265 steps', Icons.directions_walk),
  ],
  about:
      'Bremen’s Protestant cathedral, right next to the Marktplatz. The two '
      'west towers are about 93 m high. If you want to go up, the south '
      'tower has 265 steps.',
  story:
      'There has been a church here since about 789. The oldest parts you '
      'can still see are the crypts, from the 11th century. Down in the '
      'Bleikeller, eight mummified bodies lie in coffins with glass lids.',
  tradition:
      'Unmarried people who turn 30 have to sweep the cathedral steps while '
      'their friends watch. They can only stop when a “virgin” kisses them. '
      'The custom goes back to about 1890.',
  address: 'Sandstraße 10-12, 28195 Bremen',
  price: 'Dom-Museum free. Tower and Bleikeller: check prices.',
  access: 'Check opening times. Tower and Bleikeller are seasonal.',
  photos: [
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1721412045350-d95576d8a762'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Jahanzeb Ahsan',
      caption: 'The two west towers',
    ),
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1764505879196-2e3e5dd40208'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Nikolai Kolosov',
      caption: 'The cathedral from the square',
    ),
    StoryPhoto(
      url:
          'https://images.unsplash.com/photo-1783614678134-5d7fde73a46a'
          '?auto=format&fit=crop&w=1200&q=75',
      author: 'Alexandre Valdivia',
      caption: 'Trams pass the cathedral',
    ),
  ],
  nearby: [
    NearbySight(
      name: 'Domshof',
      line:
          'The square north of the cathedral, with the Neptune Fountain from '
          '1991.',
      chip: '≈ 100 m',
      icon: Icons.place,
    ),
    NearbySight(
      name: 'Bremer Loch',
      line:
          'A coin slot in the pavement by the Bürgerschaft. Drop a coin in '
          'and you’ll hear the animals.',
      chip: 'Finale',
      isCoin: true,
      onRoute: true,
    ),
    NearbySight(
      name: 'Bremen Town Musicians',
      line: 'Back to stop 1, the statue where your band started.',
      chip: 'Stop 1 · ≈ 100 m',
      animal: Animal.donkey,
      onRoute: true,
    ),
  ],
);
