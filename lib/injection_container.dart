import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  // sl.registerFactory(() => AuthBloc(sl()));

  // Use cases
  // sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  // );

  // Data sources
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(client: sl()),
  // );

  // Features - Income
  // TODO: Register Income feature dependencies

  // Features - Budget
  // TODO: Register Budget feature dependencies

  // Features - Reminders
  // TODO: Register Reminders feature dependencies

  // Features - Education
  // TODO: Register Education feature dependencies

  // Core
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  // sl.registerLazySingleton(() => http.Client());
  // sl.registerLazySingleton(() => FirebaseFirestore.instance);
  // sl.registerLazySingleton(() => FirebaseAuth.instance);
}
