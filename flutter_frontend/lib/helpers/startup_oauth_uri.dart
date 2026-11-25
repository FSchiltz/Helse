Uri? startupOAuthUri(Iterable<String> arguments) {
  for (final argument in arguments) {
    final uri = Uri.tryParse(argument);
    if (uri?.scheme == 'com.helse' && uri?.host == 'login-callback') {
      return uri;
    }
  }
  return null;
}
