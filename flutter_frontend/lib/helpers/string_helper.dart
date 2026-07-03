extension ListCase on Iterable<String> {
  String toCamel() {
    final firstChar = first[0];
    final rest = map((e) => e.toLowerCase()).join(' ');
    return '${firstChar.toUpperCase()}${rest.substring(1, rest.length)}';
  }
}

extension Case on String {
  String toCamel() {
    final firstChar = this[0];
    return '${firstChar.toUpperCase()}${substring(1, length).toLowerCase()}';
  }
}
