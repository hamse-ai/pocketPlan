import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocket_plan/features/settings/data/data_sources/settings_local_datasource.dart';
import 'package:pocket_plan/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:pocket_plan/features/settings/domain/repositories/settings_repository.dart';
import 'package:pocket_plan/features/settings/domain/usecases/get_settings.dart';
import 'package:pocket_plan/features/settings/domain/usecases/save_settings.dart';
import 'package:pocket_plan/features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── External ────────────────────────────────────────────────────────────────
  // SharedPreferences must be awaited before anything else uses it.
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ── Features – Settings ─────────────────────────────────────────────────────

  // Presentation
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      saveSettings: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveSettings(sl()));

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  // Data sources
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
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // sl.registerLazySingleton(() => FirebaseFirestore.instance);
  // sl.registerLazySingleton(() => FirebaseAuth.instance);
}
