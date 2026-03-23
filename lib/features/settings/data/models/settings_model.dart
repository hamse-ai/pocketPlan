import '../../domain/entities/settings.dart';

class SettingsModel extends Settings {
  const SettingsModel({
    required super.autoSaveNotifications,
    required super.weeklySummary,
    required super.showBalance,
    required super.shareAnalytics,
    required super.theme,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      autoSaveNotifications: json['autoSaveNotifications'],
      weeklySummary: json['weeklySummary'],
      showBalance: json['showBalance'],
      shareAnalytics: json['shareAnalytics'],
      theme: json['theme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoSaveNotifications': autoSaveNotifications,
      'weeklySummary': weeklySummary,
      'showBalance': showBalance,
      'shareAnalytics': shareAnalytics,
      'theme': theme,
    };
  }
}