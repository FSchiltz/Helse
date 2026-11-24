class ServiceError {
  final String message;
  final Object? description;
  final int code;

  ServiceError(this.code, {required this.message, this.description});

  bool _isClientError() {
    return code < 500 && code >= 400;
  }

  @override
  String toString() {
    if (_isClientError()) {
      return _clientErrorDescription() ?? message;
    }

    return "Server error";
  }

  String? _clientErrorDescription() {
    final value = description;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    if (value is Map) {
      final errors = value['errors'];
      if (errors is Map) {
        final messages = errors.entries
            .map((entry) {
              final detail = _formatErrorValue(entry.value);
              return detail == null ? null : '${entry.key}: $detail';
            })
            .whereType<String>()
            .toList();
        if (messages.isNotEmpty) {
          return messages.join('; ');
        }
      }

      for (final key in ['detail', 'message', 'title', 'error']) {
        final detail = _formatErrorValue(value[key]);
        if (detail != null) {
          return detail;
        }
      }
    }

    return null;
  }

  String? _formatErrorValue(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    if (value is Iterable) {
      final details = value.map(_formatErrorValue).whereType<String>().toList();
      return details.isEmpty ? null : details.join(', ');
    }
    return null;
  }
}
