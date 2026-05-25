import 'package:web/web.dart' as web;

class UrlHelper {
  static void removeParam() {
    web.window.history.replaceState(web.window.history.state, 'title', '/');
  }
}
