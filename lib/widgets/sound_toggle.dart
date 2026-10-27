import 'package:flutter/material.dart';

import '../services/sound_service.dart';
import '../theme/app_motion.dart';
import 'round_icon_button.dart';

/// The one mute switch for every sound (Figma "Sound Toggle").
///
/// It listens to SoundService.muted, so the speaker icons on Home and on the
/// concert screen always show the same state.
class SoundToggle extends StatelessWidget {
  const SoundToggle({super.key, this.variant = RoundButtonVariant.ghost});

  final RoundButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final sound = SoundService.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: sound.muted,
      builder: (context, muted, _) => RoundIconButton(
        variant: variant,
        tooltip: muted ? 'Turn sound on' : 'Turn sound off',
        onPressed: sound.toggleMute,
        icon: AnimatedSwitcher(
          duration: AppMotion.fast,
          child: Icon(
            muted ? Icons.volume_off : Icons.volume_up,
            key: ValueKey(muted),
          ),
        ),
      ),
    );
  }
}
