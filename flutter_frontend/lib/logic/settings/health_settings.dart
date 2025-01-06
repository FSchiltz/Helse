class HealthSettings {
  static const _syncHealth = "syncHealth";
  bool syncHealth;

  HealthSettings(this.syncHealth);

  // stupid boilerplate code because dart can't decode json
  HealthSettings.fromJson(dynamic json)
      : syncHealth = json[_syncHealth] as bool? ?? false;

  Map<String, dynamic> toJson() => {
        _syncHealth: syncHealth,
      };
}
