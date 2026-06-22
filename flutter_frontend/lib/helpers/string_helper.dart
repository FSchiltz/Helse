extension Case on Iterable<String> {
  String toCamel() {
    final firstChar = first[0];
    final rest = map((e) => e.toLowerCase()).join(' ');
    return '${firstChar.toUpperCase()}${rest.substring(1, rest.length - 1)}';
  }
}
