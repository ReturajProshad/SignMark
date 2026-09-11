/// Default values for PDF drawing operations, expressed in PDF points
/// (1 pt = 1/72 inch).
abstract final class PdfDefaults {
  // --- Signature ---
  /// Default typed-signature font size (within the 20–80 pt UI range).
  static const double signatureFontSize = 40;
  static const double signatureMinFontSize = 20;
  static const double signatureMaxFontSize = 80;

  /// The signature is placed bottom-center of page 1 by default. This is the
  /// margin from the bottom edge of the page, in points.
  static const double signatureBottomMarginPts = 64;

  // --- Watermark ---
  static const double watermarkFontSize = 48;

  /// Transparency slider is 0–100 (%).
  static const int watermarkOpacityPercent = 50;
  static const int watermarkMinOpacityPercent = 0;
  static const int watermarkMaxOpacityPercent = 100;

  /// Rotation slider is 0–360 (degrees).
  static const double watermarkRotationDegrees = 0;
  static const double watermarkMinRotationDegrees = 0;
  static const double watermarkMaxRotationDegrees = 360;

  /// Margin from page edges for watermark placement, in points.
  static const double watermarkBottomMarginPts = 48;
}
