import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs before every test file.
///
/// Widget tests normally draw text with a test font whose letters are much
/// wider than Roboto. This loads the real Roboto that ships with the Flutter
/// SDK, so the overflow checks measure text like a phone does.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fonts = _materialFontsDirectory();
  if (fonts != null) {
    final roboto = FontLoader('Roboto');
    for (final weight in ['regular', 'medium', 'bold', 'black']) {
      final file = File('${fonts.path}/roboto-$weight.ttf');
      roboto.addFont(file.readAsBytes().then(ByteData.sublistView));
    }
    await roboto.load();
  }
  await testMain();
}

/// `flutter/bin/cache/artifacts/material_fonts`, found by walking up from
/// the test runner (it lives in the same cache folder).
Directory? _materialFontsDirectory() {
  var dir = File(Platform.resolvedExecutable).parent;
  while (dir.parent.path != dir.path) {
    final fonts = Directory('${dir.path}/material_fonts');
    if (fonts.existsSync()) return fonts;
    dir = dir.parent;
  }
  return null;
}
