class HealthSettings {
  static const _syncHealth = "syncHealth";
  static const _background = "background";
  static const _history = "history";
  static const _records = "records";
  bool syncHealth;
  bool background;
  bool history;
  Map<String, HealthRecordSettings> records;

  HealthSettings(this.syncHealth, this.history, this.background, this.records);

  // stupid boilerplate code because dart can't decode json
  factory HealthSettings.fromJson(Map<String, dynamic> json) {
    final recordsJson = json[_records] as Map<String, dynamic>?;

    return HealthSettings(
      json[_syncHealth] as bool? ?? false,
      json[_history] as bool? ?? false,
      json[_background] as bool? ?? false,
      recordsJson?.map(
            (key, value) => MapEntry(
              key,
              HealthRecordSettings.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() => {
    _syncHealth: syncHealth,
    _background: background,
    _history: history,
    _records: records.map((key, value) => MapEntry(key, value.toJson())),
  };
}

class HealthRecordSettings {
  static const String _sync = "sync";
  bool sync;

  HealthRecordSettings(this.sync);

  factory HealthRecordSettings.fromJson(Map<String, dynamic> json) {
    return HealthRecordSettings(json[_sync] as bool? ?? false);
  }

  Map<String, dynamic> toJson() => {_sync: sync};
}
