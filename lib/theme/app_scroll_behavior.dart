import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Material scrolling, but a mouse can drag too.
///
/// Flutter leaves the mouse out of drag scrolling, so in Chrome on a laptop
/// the photos would not swipe and the story sheet would not slide up. With
/// the mouse added, click and drag works like a finger on a phone.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
  };
}
