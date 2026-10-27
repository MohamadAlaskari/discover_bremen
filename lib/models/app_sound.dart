/// Every short sound in the app.
///
/// The names match the Figma variables (collection "Sound") and each one
/// points to one file in assets/sounds/. The band songs band_1 … band_4 are
/// picked by number in SoundService.playBand().
enum AppSound {
  stamp('sfx_stamp.mp3'),
  coin('sfx_coin.mp3'),
  undo('sfx_undo.mp3'),
  donkey('voice_donkey.mp3'),
  dog('voice_dog.mp3'),
  cat('voice_cat.mp3'),
  rooster('voice_rooster.mp3');

  const AppSound(this.file);

  final String file;

  /// Effects (sfx_*) use the low-latency player, voices the normal one.
  bool get isEffect => file.startsWith('sfx_');
}
