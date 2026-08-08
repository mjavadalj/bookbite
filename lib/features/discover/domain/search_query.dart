class SearchQuery {
  const SearchQuery._(this.display, this.value, this.isIsbn);

  final String display;
  final String value;
  final bool isIsbn;

  static SearchQuery? parse(String input) {
    final withoutControls = input.replaceAll(
      RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'),
      '',
    );
    final value = withoutControls.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (value.isEmpty || value.runes.length > 200) return null;
    final isbn = _normalizeIsbn(value);
    return SearchQuery._(input, value, _isIsbnLike(isbn));
  }

  static String _normalizeIsbn(String value) => value
      .replaceAll(RegExp(r'[\s-]'), '')
      .replaceAllMapped(
        RegExp(r'[۰-۹]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) - 1728),
      )
      .replaceFirst(RegExp(r'x$', caseSensitive: false), 'X');

  static bool _isIsbnLike(String value) =>
      RegExp(r'^\d{9}[\dX]$').hasMatch(value) ||
      RegExp(r'^\d{13}$').hasMatch(value);
}
