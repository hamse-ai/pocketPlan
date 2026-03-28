import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_plan/firebase_options.dart';

// Settings feature
import 'package:pocket_plan/features/settings/data/data_sources/settings_local_datasource.dart';
import 'package:pocket_plan/features/settings/data/data_sources/settings_firebase_datasource.dart';
import 'package:pocket_plan/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:pocket_plan/features/settings/domain/repositories/settings_repository.dart';
import 'package:pocket_plan/features/settings/domain/usecases/get_settings.dart';
import 'package:pocket_plan/features/settings/domain/usecases/save_settings.dart';
import 'package:pocket_plan/features/settings/domain/usecases/account_management_usecases.dart';
import 'package:pocket_plan/features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Firebase Initialization ─────────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── External Dependencies ───────────────────────────────────────────────────
  
  // SharedPreferences for local caching
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Firebase instances
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // ── Features – Settings ─────────────────────────────────────────────────────

  // Presentation (Bloc)
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      saveSettings: sl(),
      changePassword: sl(),
      deleteAccount: sl(),
      downloadUserData: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveSettings(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => DeleteAccount(auth: sl(), firestore: sl()));
  sl.registerLazySingleton(() => DownloadUserData(auth: sl(), firestore: sl()));

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      firebaseDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SettingsFirebaseDataSource>(
    () => SettingsFirebaseDataSourceImpl(
      firestore: sl(),
      auth: sl(),
    ),
  );
  
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ── Features – Auth ─────────────────────────────────────────────────────────
  // sl.registerFactory(() => AuthBloc(sl()));
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  // );
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(client: sl()),
  // );

  // ── Features – Income ───────────────────────────────────────────────────────
  // TODO: Register Income feature dependencies

  // ── Features – Budget ───────────────────────────────────────────────────────
  // TODO: Register Budget feature dependencies

  // ── Features – Reminders ────────────────────────────────────────────────────
  // TODO: Register Reminders feature dependencies

  // ── Features – Education ────────────────────────────────────────────────────
  // TODO: Register Education feature dependencies

  // ── Core ────────────────────────────────────────────────────────────────────
  // Network info and other core services can be registered here
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}