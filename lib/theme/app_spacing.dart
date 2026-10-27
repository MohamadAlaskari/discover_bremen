/// Spacing scale from the Figma variables (collection "Dimensions"):
/// 4 · 8 · 12 · 16 · 20 · 24 · 32 · 48. Paddings and gaps only use these.
abstract final class AppSpacing {
  static const xxs = 4.0; // spacing/2xs
  static const xs = 8.0; // spacing/xs
  static const sm = 12.0; // spacing/sm
  static const md = 16.0; // spacing/md
  static const lg = 20.0; // spacing/lg
  static const xl = 24.0; // spacing/xl
  static const xxl = 32.0; // spacing/2xl
  static const xxxl = 48.0; // spacing/3xl, also the minimum touch target
}

/// Corner radius scale: 8 · 12 · 16 · 24 · full.
abstract final class AppRadius {
  static const sm = 8.0; // snackbar, small stamp
  static const md = 12.0; // text field, big stamp
  static const lg = 16.0; // cards, buttons
  static const xl = 24.0; // band card, details sheet
  static const full = 999.0; // pills, chips, round buttons
}
