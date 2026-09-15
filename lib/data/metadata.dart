

class Metadata {
  const Metadata({required this.title, required this.artist});

  final String? title;
  final String? artist;

  static bool isNonEmpty(String? input) {
    return (input != null && input.trim().isNotEmpty);
  }
}