import 'dart:io';

import 'startup_oauth_uri.dart' as parser;

Uri? getStartupOAuthUri() =>
    parser.startupOAuthUri(Platform.executableArguments);
