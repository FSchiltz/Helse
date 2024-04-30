import 'dart:html' as html;

class UrlHelper {
  static void removeParam() {
    dynamic state = {};
    state.serialCount = 0;
    state.state = null;
    html.window.history.replaceState(state, 'title', '/');
  }
}
