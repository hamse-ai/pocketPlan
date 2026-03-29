import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final bool autoSaveNotifications;
  final bool weeklySummary;
  final bool showBalance;
  final bool shareAnalytics;
  final bool notificationsEnabled;

  // Profile fields — populated from Firebase once auth is wired up.
  // Until then they hold empty strings (safe defaults).
  final String userName;
  final String email;

  const Settings({
    required this.autoSaveNotifications,
    required this.weeklySummary,
    required this.showBalance,
    required this.shareAnalytics,
    required this.notificationsEnabled,
    this.userName = '',
    this.email = '',
  });

  Settings copyWith({
    bool? autoSaveNotifications,
    bool? weeklySummary,
    bool? showBalance,
    bool? shareAnalytics,
    bool? notificationsEnabled,
    String? userName,
    String? email,
  }) {
    return Settings(
      autoSaveNotifications:
          autoSaveNotifications ?? this.autoSaveNotifications,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      showBalance: showBalance ?? this.showBalance,
      shareAnalytics: shareAnalytics ?? this.shareAnalytics,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      userName: userName ?? this.userName,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [
        autoSaveNotifications,
        weeklySummary,
        showBalance,
        shareAnalytics,
        notificationsEnabled,
        userName,
        email,
      ];
}
