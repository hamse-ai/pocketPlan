import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/settings_firebase_datasource.dart';
import '../data_sources/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsFirebaseDataSource firebaseDataSource;
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    required this.firebaseDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      // Try Firestore first
      final firebaseSettings = await firebaseDataSource.getSettings();
      
      // Get user profile from Firebase Auth
      final profile = await firebaseDataSource.getUserProfile();
      
      // Merge profile data into settings
      final settingsWithProfile = SettingsModel(
        autoSaveNotifications: firebaseSettings.autoSaveNotifications,
        weeklySummary: firebaseSettings.weeklySummary,
        showBalance: firebaseSettings.showBalance,
        shareAnalytics: firebaseSettings.shareAnalytics,
        theme: firebaseSettings.theme,
        notificationsEnabled: firebaseSettings.notificationsEnabled,
        userName: profile['userName'] ?? '',
        email: profile['email'] ?? '',
      );
      
      // Cache locally for offline access
      await localDataSource.saveSettings(settingsWithProfile);
      
      return Right(settingsWithProfile);
    } on ServerException {
      // Fallback to local cache if Firestore fails
      try {
        final cachedSettings = await localDataSource.getSettings();
        return Right(cachedSettings);
      } catch (e) {
        return const Left(ServerFailure('Failed to load settings'));
      }
    } catch (e) {
      return const Left(ServerFailure('Failed to load settings'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(Settings settings) async {
    try {
      final settingsModel = SettingsModel.fromEntity(settings);
      
      // Save to Firestore
      await firebaseDataSource.saveSettings(settingsModel);
      
      // Update local cache
      await localDataSource.saveSettings(settingsModel);
      
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Failed to save settings'));
    } catch (e) {
      return const Left(ServerFailure('Failed to save settings'));
    }
  }
}