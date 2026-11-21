class ServiceError {
  final String message;
  final String? description;
  final int code;

  ServiceError(this.code, {required this.message, this.description});

  bool _isClientError() {
    return code < 500 && code >= 400;
  }

  @override
  String toString() {
    // TODO better manage the return values
    if (_isClientError()) {
      return "Invalid object state";
    }

    return "Server error";
  }
}
