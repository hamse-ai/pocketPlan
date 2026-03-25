import '../../domain/entities/settings.dart';

class SettingsModel extends Settings {
  const SettingsModel({
    required super.autoSaveNotifications,
    required super.weeklySummary,
    required super.showBalance,
    required super.shareAnalytics,
    required super.theme,
    required super.notificationsEnabled, // NEW FIELD
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      autoSaveNotifications: json['autoSaveNotifications'],
      weeklySummary: json['weeklySummary'],
      showBalance: json['showBalance'],
      shareAnalytics: json['shareAnalytics'],
      theme: json['theme'],
      notificationsEnabled: json['notificationsEnabled'], // NEW FIELD
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoSaveNotifications': autoSaveNotifications,
      'weeklySummary': weeklySummary,
      'showBalance': showBalance,
      'shareAnalytics': shareAnalytics,
      'theme': theme,
      'notificationsEnabled': notificationsEnabled, // NEW FIELD
    };
  }
}