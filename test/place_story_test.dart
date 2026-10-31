import 'package:discover_bremen/data/places.dart';
import 'package:discover_bremen/screens/place_details_screen.dart';
import 'package:discover_bremen/screens/place_story_screen.dart';
import 'package:discover_bremen/theme/app_scroll_behavior.dart';
import 'package:discover_bremen/theme/app_theme.dart';
import 'package:discover_bremen/widgets/page_dots.dart';
import 'package:discover_bremen/widgets/photo_carousel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Widget tests have no internet (every image request fails), so these tests
// also show what the screen looks like offline: placeholders, no errors.

const small = Size(360, 640);
const large = Size(430, 932);

void useScreen(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Theme and scroll behavior as in main.dart.
Widget app(Widget home) => MaterialApp(
  theme: AppTheme.light(),
  scrollBehavior: const AppScrollBehavior(),
  home: home,
);

/// Drags the sheet up and scrolls its text to the end.
Future<void> scrollSheetToEnd(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('every details screen opens its own story', (tester) async {
    useScreen(tester, large);
    for (final place in places) {
      await tester.pumpWidget(
        app(
          PlaceDetailsScreen(key: UniqueKey(), place: place, isVisited: false),
        ),
      );
      await tester.tap(find.text('Read more'));
      await tester.pumpAndSettle();

      final story = place.story;
      expect(find.byType(PlaceStoryScreen), findsOneWidget);
      expect(find.text(place.overline.toUpperCase()), findsOneWidget);
      expect(find.text(story.about), findsOneWidget);
      // Offline: the first photo shows its placeholder caption instead.
      expect(find.text(story.photos.first.caption), findsOneWidget);
      expect(find.text(story.photos.first.credit), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Back to the details screen; reading changes nothing there.
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Mark as Visited'), findsOneWidget);
    }
  });

  testWidgets('photos swipe and the dots follow', (tester) async {
    useScreen(tester, large);
    final story = places.first.story;
    await tester.pumpWidget(app(PlaceStoryScreen(place: places.first)));
    await tester.pumpAndSettle();
    expect(tester.widget<PageDots>(find.byType(PageDots)).page, 0);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(tester.widget<PageDots>(find.byType(PageDots)).page, 1);
    expect(find.text(story.photos[1].credit), findsOneWidget);
    expect(find.text(story.photos[1].caption), findsOneWidget);
  });

  testWidgets('the sheet slides up over the fixed photo', (tester) async {
    useScreen(tester, large);
    final place = places.first;
    await tester.pumpWidget(app(PlaceStoryScreen(place: place)));
    await tester.pumpAndSettle();

    final photoTop = tester.getTopLeft(find.byType(PhotoCarousel)).dy;
    final titleBefore = tester.getTopLeft(find.text(place.name)).dy;
    // The sheet starts 30 px above the bottom of the 360 px photo.
    expect(titleBefore, greaterThan(PhotoCarousel.height - 30));

    await tester.drag(find.text('The story'), const Offset(0, -300));
    await tester.pumpAndSettle();
    final titleAfter = tester.getTopLeft(find.text(place.name)).dy;
    expect(titleAfter, lessThan(titleBefore - 200)); // snapped up
    expect(tester.getTopLeft(find.byType(PhotoCarousel)).dy, photoTop);

    // Tapping the grip closes it again.
    await tester.tap(
      find.bySemanticsLabel(RegExp('Show more or less of the text')),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text(place.name)).dy, titleBefore);
  });

  testWidgets('a mouse swipes the photos and pulls the sheet (Chrome)', (
    tester,
  ) async {
    useScreen(tester, large);
    final place = places.first;
    await tester.pumpWidget(app(PlaceStoryScreen(place: place)));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(PageView),
      const Offset(-400, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<PageDots>(find.byType(PageDots)).page, 1);

    final titleBefore = tester.getTopLeft(find.text(place.name)).dy;
    await tester.drag(
      find.text('The story'),
      const Offset(0, -300),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text(place.name)).dy,
      lessThan(titleBefore - 200),
    );
  });

  testWidgets('all sections from Figma and the photo credits', (tester) async {
    useScreen(tester, large);
    for (final place in places) {
      final story = place.story;
      await tester.pumpWidget(
        app(PlaceStoryScreen(key: UniqueKey(), place: place)),
      );
      await tester.pumpAndSettle();
      for (final chip in story.chips) {
        expect(find.text(chip.label), findsWidgets);
      }
      expect(find.text('About'), findsOneWidget);
      expect(find.text('The story'), findsOneWidget);
      expect(find.text(story.story), findsOneWidget);

      await scrollSheetToEnd(tester);
      expect(find.text('Local tradition'), findsOneWidget);
      expect(find.text(story.tradition), findsOneWidget);
      expect(find.text('Location & visit'), findsOneWidget);
      expect(find.text(story.address), findsOneWidget);
      expect(find.text('Nearby sights'), findsOneWidget);
      for (final sight in story.nearby) {
        expect(find.text(sight.line), findsOneWidget);
        // Two sights can share a distance ("≈ 50 m").
        expect(find.text(sight.chip), findsWidgets);
      }
      expect(find.text('PHOTO CREDITS'), findsOneWidget);
      expect(
        find.text(
          'Photos from Unsplash (Unsplash License): ${story.photographers}.',
        ),
        findsOneWidget,
      );
    }
  });

  // An overflow (yellow and black stripes) is reported as an error and
  // fails the test.
  for (final size in [small, large]) {
    final label = '${size.width.toInt()}×${size.height.toInt()}';
    testWidgets('no overflow on $label: every story, sheet down and up', (
      tester,
    ) async {
      useScreen(tester, size);
      for (final place in places) {
        await tester.pumpWidget(
          app(PlaceStoryScreen(key: UniqueKey(), place: place)),
        );
        await tester.pumpAndSettle();
        await scrollSheetToEnd(tester);
        expect(find.text('PHOTO CREDITS'), findsOneWidget);
      }
    });
  }
}
