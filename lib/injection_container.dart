import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:pocket_plan/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/sign_in_with_email.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up_with_email.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/income/data/datasources/transaction_remote_data_source.dart';
import 'features/income/data/repositories/transaction_repository_impl.dart';
import 'features/income/domain/repositories/transaction_repository.dart';
import 'features/income/domain/usecases/transaction_usecases.dart';
import 'features/income/presentation/bloc/income_bloc.dart';
import 'features/budget/presentation/bloc/expense_bloc.dart';

import 'features/profile/data/data_sources/profile_firebase_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/update_profile.dart';
import 'features/profile/domain/usecases/upload_profile_photo.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

import 'features/settings/data/data_sources/settings_firebase_datasource.dart';
import 'features/settings/data/data_sources/settings_local_datasource.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/account_management_usecases.dart';
import 'features/settings/domain/usecases/get_settings.dart';
import 'features/settings/domain/usecases/save_settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => gsi.GoogleSignIn());

  // ── Auth ───────────────────────────────────────────────────────────────────
  sl.registerFactory(
    () => AuthBloc(
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signInWithGoogle: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
    ),
  );

  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  // Features - Transactions (Income/Expense)
  // Bloc
  sl.registerFactory(() => IncomeBloc(
        getTransactions: sl(),
        addTransactionUseCase: sl(),
        toggleTransactionStatusUseCase: sl(),
      ));
  sl.registerFactory(() => ExpenseBloc(
        getTransactions: sl(),
        addTransactionUseCase: sl(),
        toggleTransactionStatusUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => ToggleTransactionStatus(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
      firebaseAuth: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(firestore: sl()),
  );

  // --- Profile Features ---
  // Bloc
  sl.registerFactory(() => ProfileBloc(
        getProfile: sl(),
        updateProfile: sl(),
        uploadProfilePhoto: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => UploadProfilePhoto(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remote: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileFirebaseDataSource>(
    () => ProfileFirebaseDataSourceImpl(
      firestore: sl(),
      auth: sl(),
      storage: sl(),
    ),
  );

  // --- Settings Features ---
  // Bloc
  sl.registerFactory(() => SettingsBloc(
        getSettings: sl(),
        saveSettings: sl(),
        changePassword: sl(),
        deleteAccount: sl(),
        downloadUserData: sl(),
      ));

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
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
}
