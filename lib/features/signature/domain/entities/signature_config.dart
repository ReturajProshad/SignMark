/// Bundled signature font metadata.
class SignatureFont {
  const SignatureFont({
    required this.family,
    required this.label,
    required this.assetFileName,
  });

  final String family;
  final String label;
  final String assetFileName;

  static const List<SignatureFont> all = [
    SignatureFont(
      family: 'DancingScript',
      label: 'Dancing Script',
      assetFileName: 'DancingScript-Regular.ttf',
    ),
    SignatureFont(
      family: 'Sacramento',
      label: 'Sacramento',
      assetFileName: 'Sacramento-Regular.ttf',
    ),
    SignatureFont(
      family: 'AlexBrush',
      label: 'Alex Brush',
      assetFileName: 'AlexBrush-Regular.ttf',
    ),
    SignatureFont(
      family: 'Allura',
      label: 'Allura',
      assetFileName: 'Allura-Regular.ttf',
    ),
    SignatureFont(
      family: 'Caveat',
      label: 'Caveat',
      assetFileName: 'Caveat-Regular.ttf',
    ),
  ];
}
