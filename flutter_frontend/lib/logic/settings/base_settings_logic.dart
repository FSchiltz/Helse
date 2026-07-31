import 'dart:convert';
import 'package:helse/services/account.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class BaseSettingsLogic {
  final Account account;
  final int settingsVersion = 2;

  BaseSettingsLogic(this.account);

  Future<void> save(String key, Map<String, dynamic> data) async {
    await account.storage.setString(key, json.encode(data));
  }

  String? getString(String key) {
    return account.storage.getString(key);
  }

  bool? getBool(String key) {
    return account.storage.getBool(key);
  }

  Future<void> setBool(String key, bool value) async {
    await account.storage.setBool(key, value);
  }

  Future<void> setString(String key, String value) async {
    await account.storage.setString(key, value);
  }

  Future<void> remove(String key) async {
    await account.storage.remove(key);
  }

    OrderedItem getDefaultMetricType(MetricType item) {
    if (item.type == MetricDataType.number) {
      return OrderedItem(
        id: item.id,
        name: item.name,
        graph: GraphKind.bar,
        detailGraph: GraphKind.line,
        visible: item.visible,
        showOnDashboard: true,
        parent: item.groupId,
      );
    }

    return OrderedItem(
      id: item.id,
      name: item.name,
      graph: GraphKind.text,
      detailGraph: GraphKind.text,
      visible: item.visible,
      showOnDashboard: true,
      parent: item.groupId,
    );
  }
}
