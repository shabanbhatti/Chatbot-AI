extension GetFirstLastInitialExtension on String {
  String get initials {
    if (trim().isEmpty) return '';

    final words = trim().split(RegExp(r'\s+'));

    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }

    return (words.first[0] + words.last[0]).toUpperCase();
  }
}
