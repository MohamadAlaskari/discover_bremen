import 'package:discover_bremen/data/places.dart';
import 'package:discover_bremen/main.dart';
import 'package:discover_bremen/screens/band_complete_screen.dart';
import 'package:discover_bremen/screens/concert_screen.dart';
import 'package:discover_bremen/screens/home_screen.dart';
import 'package:discover_bremen/screens/onboarding_screen.dart';
import 'package:discover_bremen/screens/place_details_screen.dart';
import 'package:discover_bremen/services/sound_service.dart';
import 'package:discover_bremen/theme/app_motion.dart';
import 'package:discover_bremen/theme/app_theme.dart';
import 'package:discover_bremen/widgets/route_stop_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The two phone sizes from the brief: small and large.
const small = Size(360, 640);
const large = Size(430, 932);

void useScreen(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Widget app(Widget home) => MaterialApp(theme: AppTheme.light(), home: home);

/// Mark as Visited and wait for the whole sequence (stamp → voice → snackbar).
Future<void> markVisited(WidgetTester tester) async {
  await tester.tap(find.text('Mark as Visited'));
  await tester.pump(AppMotion.stampImpact);
  await tester.pump(AppMotion.voiceDelay);
  await tester.pump(AppMotion.snackbarDelay);
  await tester.pump(const Duration(milliseconds: 500)); // snackbar slides in
}

/// Open a stop from Home, mark it and go back with the result.
Future<void> visit(WidgetTester tester, String shortName) async {
  await tester.scrollUntilVisible(find.text(shortName), 100);
  await tester.tap(find.text(shortName));
  await tester.pumpAndSettle();
  await markVisited(tester);
  await tester.tap(find.text('Back to your route'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('onboarding: skip, enter a name, start the journey', (
    tester,
  ) async {
    useScreen(tester, small);
    await tester.pumpWidget(const DiscoverBremenApp());
    expect(find.text('Four animals set off for Bremen.'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Now you are the fifth musician.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Anna');
    await tester.tap(find.text('Start my journey'));
    await tester.pumpAndSettle();
    expect(find.text('WELCOME, ANNA'), findsOneWidget);
    expect(find.text('Discover Bremen'), findsOneWidget);
  });

  testWidgets('home lists the 4 stops in a ListView.builder', (tester) async {
    useScreen(tester, large);
    await tester.pumpWidget(app(const HomeScreen(userName: 'Anna')));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(RouteStopTile), findsNWidgets(places.length));
    expect(find.text('0 of 4 musicians'), findsOneWidget);
    expect(find.text('4 stops · ~2 km'), findsOneWidget);
    // No band yet, so nothing to listen to.
    expect(find.text('Hear your band'), findsNothing);
  });

  testWidgets('mark as visited → back → the list shows the visit', (
    tester,
  ) async {
    useScreen(tester, large);
    await tester.pumpWidget(app(const HomeScreen(userName: 'Anna')));

    await tester.tap(find.text('Town Musicians'));
    await tester.pumpAndSettle();
    expect(find.text('Bremen Town Musicians'), findsOneWidget);

    await markVisited(tester);
    expect(find.text('Visited today'), findsOneWidget);
    expect(find.text('I-A!'), findsOneWidget);
    expect(find.text('The donkey joined your band'), findsOneWidget);
    expect(find.text('UNDO'), findsOneWidget);

    await tester.tap(find.text('Back to your route'));
    await tester.pumpAndSettle();
    expect(find.text('1 of 4 musicians'), findsOneWidget);
    expect(find.text('The donkey joined your band.'), findsOneWidget);
    expect(find.text('3 left'), findsOneWidget);
    expect(find.text('Hear your band'), findsOneWidget);
    final firstTile = tester.widget<RouteStopTile>(
      find.byType(RouteStopTile).first,
    );
    expect(firstTile.status, StopStatus.visited);
  });

  testWidgets('UNDO takes the visit back', (tester) async {
    useScreen(tester, large);
    await tester.pumpWidget(app(const HomeScreen(userName: 'Anna')));
    await tester.tap(find.text('Schlachte'));
    await tester.pumpAndSettle();
    await markVisited(tester);
    expect(find.text('The dog joined your band'), findsOneWidget);

    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text('Mark as Visited'), findsOneWidget);
    expect(find.text('Visited today'), findsNothing);

    // The system back button returns the result as well.
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(find.text('0 of 4 musicians'), findsOneWidget);
  });

  testWidgets('four stops → band complete → concert → new journey', (
    tester,
  ) async {
    useScreen(tester, large);
    await tester.pumpWidget(app(const HomeScreen(userName: 'Anna')));
    for (final place in places) {
      await visit(tester, place.shortName);
    }
    // The fourth animal pops into the tower, then the celebration opens.
    expect(find.text('Band complete!'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(BandCompleteScreen), findsOneWidget);
    expect(find.text('Anna'), findsOneWidget); // on the certificate

    await tester.tap(find.text('Drop a coin at the Bremer Loch'));
    // The concert loops a pulse animation, so pump instead of settle.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(ConcertScreen), findsOneWidget);

    final semantics = tester.ensureSemantics();
    await tester.tap(find.bySemanticsLabel('Coin. Drop it into the Bremer Loch'));
    semantics.dispose();
    await tester.pump(AppMotion.coinToBand);
    for (var i = 0; i < 5; i++) {
      await tester.pump(AppMotion.stagger);
    }
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Your band is playing!'), findsOneWidget);
    expect(find.text('Kikeriki!'), findsOneWidget);
    expect(find.text('New journey'), findsOneWidget);

    await tester.tap(find.text('New journey'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('0 of 4 musicians'), findsOneWidget);
  });

  testWidgets('one mute switch for every sound', (tester) async {
    useScreen(tester, large);
    await tester.pumpWidget(app(const HomeScreen(userName: 'Anna')));
    expect(SoundService.instance.muted.value, isFalse);

    await tester.tap(find.byTooltip('Turn sound off'));
    await tester.pumpAndSettle();
    expect(SoundService.instance.muted.value, isTrue);
    expect(find.byIcon(Icons.volume_off), findsOneWidget);

    await tester.tap(find.byTooltip('Turn sound on'));
    await tester.pumpAndSettle();
    expect(SoundService.instance.muted.value, isFalse);
  });

  testWidgets('About dialog names the app and the sounds', (tester) async {
    useScreen(tester, large);
    await tester.pumpWidget(app(const HomeScreen(userName: 'Anna')));
    await tester.tap(find.byTooltip('About this app'));
    await tester.pumpAndSettle();
    expect(find.text('The Fifth Musician'), findsWidgets);
    expect(find.textContaining('synthesized for this project'), findsOneWidget);
  });

  // Layout: every screen on a small and a large phone. An overflow (yellow
  // and black stripes) is reported as an error and fails the test.
  for (final size in [small, large]) {
    final label = '${size.width.toInt()}×${size.height.toInt()}';

    testWidgets('no overflow on $label: onboarding pages', (tester) async {
      useScreen(tester, size);
      await tester.pumpWidget(app(const OnboardingScreen()));
      await tester.tap(find.text('Next'));
      // Page 2 loops its walking animation, so it never "settles":
      // pump single frames until the page has scrolled in.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.text('They never arrived.'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Start my journey'), findsOneWidget);
    });

    testWidgets('no overflow on $label: details of every stop', (
      tester,
    ) async {
      useScreen(tester, size);
      for (final place in places) {
        for (final visited in [false, true]) {
          await tester.pumpWidget(
            app(
              PlaceDetailsScreen(
                key: UniqueKey(),
                place: place,
                isVisited: visited,
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text(place.name), findsOneWidget);
        }
      }
    });

    testWidgets('no overflow on $label: band complete and concert', (
      tester,
    ) async {
      useScreen(tester, size);
      await tester.pumpWidget(app(const BandCompleteScreen(userName: 'Anna')));
      await tester.pumpAndSettle();
      expect(find.text('You are the fifth musician!'), findsOneWidget);

      await tester.pumpWidget(app(const ConcertScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Tap the coin'), findsOneWidget);
    });
  }
}
