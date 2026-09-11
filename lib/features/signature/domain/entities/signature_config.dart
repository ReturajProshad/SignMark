/// Bundled signature font metadata.
class SignatureFont {
  const SignatureFont({required this.family, required this.label});

  final String family;

  final String label;

  static const List<SignatureFont> all = [
    SignatureFont(family: 'DancingScript', label: 'Dancing Script'),
    SignatureFont(family: 'Sacramento', label: 'Sacramento'),
    SignatureFont(family: 'AlexBrush', label: 'Alex Brush'),
    SignatureFont(family: 'Allura', label: 'Allura'),
    SignatureFont(family: 'Caveat', label: 'Caveat'),
  ];
}
