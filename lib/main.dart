import 'package:flutter/material.dart';

import 'data/app_strings.dart';
import 'screens/onboarding_screen.dart';
import 'services/sound_service.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

/// Entry point: prepare the sounds, then start the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoundService.instance.init();
  runApp(const DiscoverBremenApp());
}

/// The app: one MaterialApp with the Figma theme. It starts with the
/// onboarding, which then replaces itself with Home.
class DiscoverBremenApp extends StatelessWidget {
  const DiscoverBremenApp({super.key});

  /// In a wide browser or desktop window the phone layout keeps phone width.
  static const _maxWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      builder: (context, child) => ColoredBox(
        color: AppColors.surfaceMuted,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: child,
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}
