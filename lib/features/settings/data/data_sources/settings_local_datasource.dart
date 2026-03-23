import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();

  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsModel? _cachedSettings;

  @override
  Future<SettingsModel> getSettings() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    // default values
    _cachedSettings = const SettingsModel(
      autoSaveNotifications: true,
      weeklySummary: true,
      showBalance: true,
      shareAnalytics: false,
      theme: "Light",
    );

    return _cachedSettings!;
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    _cachedSettings = settings;
  }
}