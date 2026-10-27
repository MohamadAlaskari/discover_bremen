import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_strings.dart';
import '../data/places.dart';
import '../models/animal.dart';
import '../models/place.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/animal_badge.dart';
import '../widgets/band_card.dart';
import '../widgets/round_icon_button.dart';
import '../widgets/route_stop_tile.dart';
import '../widgets/sound_toggle.dart';
import 'band_complete_screen.dart';
import 'place_details_screen.dart';

/// The route list (Figma "Home · 0 … 4 of 4 visited").
///
/// HomeScreen owns the state of the walk: the ids of the visited stops.
/// The details screen returns true/false with Navigator.pop, and setState
/// updates the band card, the tower and the tiles in one go.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userName});

  /// From the onboarding; kept in memory only.
  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Ids of the stops marked as visited.
  final Set<int> _visitedIds = {};

  /// The stop visited last, for the caption on the band card.
  int? _latestId;

  /// Time to watch the fourth animal pop into the tower before the
  /// "Band complete" screen opens.
  static const _celebrationDelay = Duration(milliseconds: 900);

  bool get _bandComplete => _visitedIds.length == places.length;

  Set<Animal> get _freedAnimals => {
    for (final place in places)
      if (_visitedIds.contains(place.id)) place.animal,
  };

  Animal? get _latestAnimal {
    for (final place in places) {
      if (place.id == _latestId) return place.animal;
    }
    return null;
  }

  /// The first stop in route order that is not visited yet. The route
  /// suggests an order, but any stop can be visited first.
  int? get _nextId {
    for (final place in places) {
      if (!_visitedIds.contains(place.id)) return place.id;
    }
    return null;
  }

  StopStatus _statusOf(Place place) {
    if (_visitedIds.contains(place.id)) return StopStatus.visited;
    return place.id == _nextId ? StopStatus.next : StopStatus.upcoming;
  }

  Future<void> _openPlace(Place place) async {
    final wasVisited = _visitedIds.contains(place.id);
    final visited = await Navigator.push<bool>(
      context,
      _detailsRoute(place, wasVisited),
    );
    if (!mounted || visited == null || visited == wasVisited) return;
    setState(() {
      if (visited) {
        _visitedIds.add(place.id);
        _latestId = place.id;
      } else {
        _visitedIds.remove(place.id);
      }
    });

    // The fourth musician just joined: let the tower fill up, then celebrate.
    if (!visited || !_bandComplete) return;
    await Future<void>.delayed(_celebrationDelay);
    if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) return;
    await _openBandComplete();
  }

  /// "Band complete" returns true when the user starts a new journey.
  Future<void> _openBandComplete() async {
    final newJourney = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BandCompleteScreen(userName: widget.userName),
      ),
    );
    if (!mounted || newJourney != true) return;
    setState(() {
      _visitedIds.clear();
      _latestId = null;
    });
  }

  /// Fades the details screen in while the animal badge flies (Hero, 450 ms).
  Route<bool> _detailsRoute(Place place, bool isVisited) {
    return PageRouteBuilder<bool>(
      transitionDuration: AppMotion.hero,
      reverseTransitionDuration: AppMotion.hero,
      pageBuilder: (_, _, _) =>
          PlaceDetailsScreen(place: place, isVisited: isVisited),
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: AppMotion.standard),
        child: child,
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: AppStrings.version,
      applicationIcon: const AnimalBadge(animal: Animal.donkey),
      applicationLegalese: '© 2026 ${AppStrings.author} · ${AppStrings.school}',
      children: const [
        SizedBox(height: AppSpacing.md),
        Text(
          '${AppStrings.tagline}: a city walk through the fairy tale of the '
          'Bremen Town Musicians.',
        ),
        SizedBox(height: AppSpacing.xs),
        Text(AppStrings.course),
        SizedBox(height: AppSpacing.xs),
        Text(
          'All sounds were synthesized for this project — no third-party '
          'samples.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _TopBar(userName: widget.userName, onInfo: _showAbout),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.md + MediaQuery.paddingOf(context).bottom,
                  ),
                  // Item 0 is the header (band card + "Your route"),
                  // then one RouteStopTile per stop.
                  itemCount: places.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _header();
                    final place = places[index - 1];
                    return RouteStopTile(
                      place: place,
                      status: _statusOf(place),
                      isFirst: index == 1,
                      isLast: index == places.length,
                      onTap: () => _openPlace(place),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final left = places.length - _visitedIds.length;
    final routeInfo = switch (left) {
      0 => 'All stops visited',
      _ when left == places.length => '${places.length} stops · ~2 km',
      _ => '$left left',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BandCard(
          freed: _freedAnimals,
          latest: _latestAnimal,
          onTap: _bandComplete ? _openBandComplete : null,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            const Expanded(
              child: Text('Your route', style: AppText.titleLarge),
            ),
            Text(
              routeInfo,
              style: AppText.bodyMedium.copyWith(
                color: left == 0 ? AppColors.success : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

/// Figma "Top Bar": greeting + title, sound toggle and the About button.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.userName, required this.onInfo});

  final String userName;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $userName'.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.overline.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Text(AppStrings.tagline, style: AppText.headlineMedium),
              ],
            ),
          ),
          const SoundToggle(),
          const SizedBox(width: AppSpacing.xxs),
          RoundIconButton(
            icon: const Icon(Icons.info),
            tooltip: 'About this app',
            onPressed: onInfo,
          ),
        ],
      ),
    );
  }
}
