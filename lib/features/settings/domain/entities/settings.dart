import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final bool autoSaveNotifications;
  final bool weeklySummary;
  final bool showBalance;
  final bool shareAnalytics;
  final String theme;
  final bool notificationsEnabled;

  const Settings({
    required this.autoSaveNotifications,
    required this.weeklySummary,
    required this.showBalance,
    required this.shareAnalytics,
    required this.theme,
    required this.notificationsEnabled, 
  });

  Settings copyWith({
    bool? autoSaveNotifications,
    bool? weeklySummary,
    bool? showBalance,
    bool? shareAnalytics,
    String? theme,
    bool? notificationsEnabled,
  }) {
    return Settings(
      autoSaveNotifications: autoSaveNotifications ?? this.autoSaveNotifications,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      showBalance: showBalance ?? this.showBalance,
      shareAnalytics: shareAnalytics ?? this.shareAnalytics,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object> get props => [
        autoSaveNotifications,
        weeklySummary,
        showBalance,
        shareAnalytics,
        theme,
        notificationsEnabled, // NEW FIELD
      ];
}