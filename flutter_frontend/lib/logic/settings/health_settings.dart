class HealthSettings {
  static const _syncHealth = "syncHealth";
  static const _background = "background";
  static const _history = "history";
  bool syncHealth;
  bool background;
  bool history;

  HealthSettings(this.syncHealth, this.history, this.background);

  // stupid boilerplate code because dart can't decode json
  HealthSettings.fromJson(dynamic json)
    : syncHealth = json[_syncHealth] as bool? ?? false,
      history = json[_history] as bool? ?? false,
      background = json[_background] as bool? ?? false;

  Map<String, dynamic> toJson() => {
    _syncHealth: syncHealth,
    _background: background,
    _history: history,
  };
}
