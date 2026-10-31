import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../models/place_story.dart';

/// The "Read more" content of every stop, keyed by place id.
///
/// Generated from docs/place_stories.json. The texts were checked against
/// the sources listed there (bremen.eu, Wikipedia, stpetridom.de, …), but
/// they are drafts like the tips: rewrite them before submitting.
/// Photos: Unsplash License, credits on each slide and under the text.
const placeStories = <int, PlaceStory>{
  // TODO(Mohamad): rewrite in your own words
  1: PlaceStory(
    chips: [
      StoryChip('Marktplatz', Icons.place),
      StoryChip('Free', Icons.euro),
      StoryChip('Open-air, any time', Icons.schedule),
    ],
    about:
        'A bronze statue of the four animals from the Grimm tale, standing on '
        'each other’s backs. It is about 2 m tall and stands at the west side '
        'of the Town Hall.',
    story:
        'The Brothers Grimm published the tale in 1819. The animals never '
        'reach Bremen: they find a robbers’ house and stay there. Gerhard '
        'Marcks made the statue. It was put up in 1953, first as a one-year '
        'trial.',
    tradition:
        'Hold both front legs of the donkey and make a wish. Locals say that '
        'one hand on one leg shows you are new in Bremen.',
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
        line: 'Gothic town hall (1405–1410), UNESCO World Heritage since 2004.',
        chip: '≈ 50 m',
        icon: Icons.account_balance,
      ),
      NearbySight(
        name: 'Bremer Roland',
        line: 'Stone knight from 1404, a symbol of the city’s freedom.',
        chip: '≈ 50 m',
        icon: Icons.shield,
      ),
      NearbySight(
        name: 'Schlachte',
        line: 'Next stop on your route: the promenade on the Weser.',
        chip: 'Stop 2 · ≈ 350 m',
        animal: Animal.dog,
        onRoute: true,
      ),
    ],
  ),

  // TODO(Mohamad): rewrite in your own words
  2: PlaceStory(
    chips: [
      StoryChip('Weser', Icons.place),
      StoryChip('Free', Icons.euro),
      StoryChip('660 m promenade', Icons.directions_walk),
    ],
    about:
        'A 660 m promenade on the Weser in the old town. Restaurants and bars '
        'line the quay, next to old ships such as the Alexander von Humboldt.',
    story:
        'The name comes from Low German slagte: the posts driven into the '
        'river bank. From the 13th century this was Bremen’s harbour. In the '
        '19th century the railway and new port basins took over. From 1993 to '
        '2000 the quay was rebuilt as a promenade.',
    tradition:
        'In winter the Schlachte-Zauber market fills the quay with about 100 '
        'wooden huts and lit-up ships, from late November to December.',
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
        line: 'Brick Gothic church by the river, first named in 1229.',
        chip: 'At the Schlachte',
        icon: Icons.church,
      ),
      NearbySight(
        name: 'Böttcherstraße',
        line: '108 m of 1920s brick art, with a porcelain Glockenspiel.',
        chip: '≈ 250 m',
        icon: Icons.music_note,
      ),
      NearbySight(
        name: 'Schnoor Quarter',
        line: 'Next stop on your route: old lanes and tiny houses.',
        chip: 'Stop 3 · ≈ 600 m',
        animal: Animal.cat,
        onRoute: true,
      ),
    ],
  ),

  // TODO(Mohamad): rewrite in your own words
  3: PlaceStory(
    chips: [
      StoryChip('Altstadt', Icons.place),
      StoryChip('Free', Icons.euro),
      StoryChip('Houses from 1401', Icons.schedule),
    ],
    about:
        'Bremen’s oldest quarter: narrow lanes with small houses, shops and '
        'cafés. Some lanes are so narrow that you can touch both walls with '
        'your arms.',
    story:
        'Fishermen, boatmen and craftsmen lived here by the Balge, an arm of '
        'the Weser. “Schnoor” means string or cord in Low German and comes '
        'from the old ship trades. The oldest house, Schnoor 2, is from 1401. '
        'Many houses were restored from 1955 on.',
    tradition:
        'Look for the Katzengang, a very narrow lane. At the Bremer Bonbon '
        'Manufaktur you can watch sweets being made by hand.',
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
            'Catholic Brick Gothic church, built in the 14th century for '
            'Franciscan monks.',
        chip: '≈ 150 m',
        icon: Icons.church,
      ),
      NearbySight(
        name: 'Kunsthalle Bremen',
        line: 'Art museum of the Kunstverein, in its own building since 1849.',
        chip: '≈ 250 m',
        icon: Icons.museum,
      ),
      NearbySight(
        name: 'St. Petri Cathedral',
        line: 'Next stop on your route: the cathedral with two 93 m towers.',
        chip: 'Stop 4 · ≈ 300 m',
        animal: Animal.rooster,
        onRoute: true,
      ),
    ],
  ),

  // TODO(Mohamad): rewrite in your own words
  4: PlaceStory(
    chips: [
      StoryChip('Domshof', Icons.place),
      StoryChip('Museum: free', Icons.euro),
      StoryChip('Tower: 265 steps', Icons.directions_walk),
    ],
    about:
        'Bremen’s Protestant cathedral, next to the Marktplatz. Its two west '
        'towers are about 93 m high, and 265 steps lead up the south tower.',
    story:
        'A church stood here from about 789. The oldest parts you can still '
        'see, the crypts, are from the 11th century. In the Bleikeller, eight '
        'mummified bodies lie in glass-topped coffins.',
    tradition:
        'Unmarried people who turn 30 sweep the cathedral steps while friends '
        'watch. They may stop when a “virgin” kisses them. The custom goes '
        'back to about 1890.',
    address: 'Sandstraße 10–12, 28195 Bremen',
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
            'Square north of the cathedral, with the Neptune Fountain (1991).',
        chip: '≈ 100 m',
        icon: Icons.place,
      ),
      NearbySight(
        name: 'Bremer Loch',
        line:
            'A coin slot in the pavement by the Bürgerschaft. Drop a coin and '
            'hear the animals.',
        chip: 'Finale',
        isCoin: true,
        onRoute: true,
      ),
      NearbySight(
        name: 'Bremen Town Musicians',
        line: 'Stop 1: the statue where your band began.',
        chip: 'Stop 1 · ≈ 100 m',
        animal: Animal.donkey,
        onRoute: true,
      ),
    ],
  ),
};
