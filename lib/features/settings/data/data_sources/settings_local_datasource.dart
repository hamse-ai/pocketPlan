import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _kSettingsKey = 'pocket_plan_settings';

  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SettingsModel> getSettings() async {
    final jsonString = sharedPreferences.getString(_kSettingsKey);

    if (jsonString != null) {
      return SettingsModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    }

    // No stored settings yet — return sensible defaults.
    return const SettingsModel(
      autoSaveNotifications: true,
      weeklySummary: true,
      showBalance: true,
      shareAnalytics: false,
      theme: 'Light',
      notificationsEnabled: true,
      userName: '',
      email: '',
    );
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    await sharedPreferences.setString(
      _kSettingsKey,
      json.encode(settings.toJson()),
    );
  }
}
