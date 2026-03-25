import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      final result = await localDataSource.getSettings();
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(Settings settings) async {
    try {
      final model = SettingsModel(
        autoSaveNotifications: settings.autoSaveNotifications,
        weeklySummary: settings.weeklySummary,
        showBalance: settings.showBalance,
        shareAnalytics: settings.shareAnalytics,
        theme: settings.theme,
        notificationsEnabled: settings.notificationsEnabled, // NEW FIELD
      );

      await localDataSource.saveSettings(model);

      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}