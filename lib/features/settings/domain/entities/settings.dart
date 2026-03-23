import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final bool autoSaveNotifications;
  final bool weeklySummary;
  final bool showBalance;
  final bool shareAnalytics;
  final String theme;

  const Settings({
    required this.autoSaveNotifications,
    required this.weeklySummary,
    required this.showBalance,
    required this.shareAnalytics,
    required this.theme,
  });

  @override
  List<Object> get props => [
        autoSaveNotifications,
        weeklySummary,
        showBalance,
        shareAnalytics,
        theme,
      ];
}