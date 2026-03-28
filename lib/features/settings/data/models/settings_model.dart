import '../../domain/entities/settings.dart';

class SettingsModel extends Settings {
  const SettingsModel({
    required super.autoSaveNotifications,
    required super.weeklySummary,
    required super.showBalance,
    required super.shareAnalytics,
    required super.theme,
    required super.notificationsEnabled,
    super.userName = '',
    super.email = '',
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      autoSaveNotifications: json['autoSaveNotifications'] as bool,
      weeklySummary: json['weeklySummary'] as bool,
      showBalance: json['showBalance'] as bool,
      shareAnalytics: json['shareAnalytics'] as bool,
      theme: json['theme'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      // Defaults to '' if the key is missing (safe for existing stored data).
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoSaveNotifications': autoSaveNotifications,
      'weeklySummary': weeklySummary,
      'showBalance': showBalance,
      'shareAnalytics': shareAnalytics,
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
      'userName': userName,
      'email': email,
    };
  }

  /// Convenience factory: build a SettingsModel from a base Settings entity.
  /// Useful in the repository layer to avoid repeating every field.
  factory SettingsModel.fromEntity(Settings s) {
    return SettingsModel(
      autoSaveNotifications: s.autoSaveNotifications,
      weeklySummary: s.weeklySummary,
      showBalance: s.showBalance,
      shareAnalytics: s.shareAnalytics,
      theme: s.theme,
      notificationsEnabled: s.notificationsEnabled,
      userName: s.userName,
      email: s.email,
    );
  }
}
