import 'dart:html' as html;

class UrlHelper {
  static void removeParam() {
    html.window.history.replaceState(html.window.history.state, 'title', '/');
  }
}
