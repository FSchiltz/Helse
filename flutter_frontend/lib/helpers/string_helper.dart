extension StringsHelper on Iterable<String> {
  String toCamel() {
    final firstChar = first[0];
    final rest = map((e) => e.toLowerCase()).join(' ');
    return '${firstChar.toUpperCase()}${rest.substring(1, rest.length)}';
  }
}

extension StringHelper on String {
  String toCamel() {
    final firstChar = this[0];
    return '${firstChar.toUpperCase()}${substring(1, length).toLowerCase()}';
  }

  String ellipsis({int count = 5}) {
    if (length <= count) {
      return this;
    }

    return '${substring(0, count)}..';
  }

  String wrap({int count = 5}) {
    if (length <= count) {
      return this;
    }

    final split = this.split(' ');
    return split.map((e) => e.ellipsis(count: count)).join('\n');
  }
}
