import 'package:cloud_firestore/cloud_firestore.dart' hide Settings;
import '../../domain/entities/settings.dart' as domain_settings;

class SettingsModel extends domain_settings.Settings {
  const SettingsModel({
    required bool autoSaveNotifications,
    required bool weeklySummary,
    required bool showBalance,
    required bool shareAnalytics,
    required String theme,
    required bool notificationsEnabled,
    String userName = '',
    String email = '',
  }) : super(
    autoSaveNotifications: autoSaveNotifications,
    weeklySummary: weeklySummary,
    showBalance: showBalance,
    shareAnalytics: shareAnalytics,
    theme: theme,
    notificationsEnabled: notificationsEnabled,
    userName: userName,
    email: email,
  );

  /// Create from JSON (for SharedPreferences - legacy support)
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      autoSaveNotifications: json['autoSaveNotifications'] as bool? ?? true,
      weeklySummary: json['weeklySummary'] as bool? ?? true,
      showBalance: json['showBalance'] as bool? ?? true,
      shareAnalytics: json['shareAnalytics'] as bool? ?? false,
      theme: json['theme'] as String? ?? 'Light',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  /// Create from Firestore document
  factory SettingsModel.fromFirestore(Map<String, dynamic> data) {
    return SettingsModel(
      autoSaveNotifications: data['autoSaveNotifications'] as bool? ?? true,
      weeklySummary: data['weeklySummary'] as bool? ?? true,
      showBalance: data['showBalance'] as bool? ?? true,
      shareAnalytics: data['shareAnalytics'] as bool? ?? false,
      theme: data['theme'] as String? ?? 'Light',
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
      userName: data['userName'] as String? ?? '',
      email: data['email'] as String? ?? '',
    );
  }

  /// Convert to JSON (for SharedPreferences - legacy support)
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

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'autoSaveNotifications': autoSaveNotifications,
      'weeklySummary': weeklySummary,
      'showBalance': showBalance,
      'shareAnalytics': shareAnalytics,
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
      'userName': userName,
      'email': email,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
  

  /// Convenience factory: build a SettingsModel from a base Settings entity
  factory SettingsModel.fromEntity(domain_settings.Settings s) {
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