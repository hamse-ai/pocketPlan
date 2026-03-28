import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';
import '../../domain/usecases/account_management_usecases.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final SaveSettings saveSettings;
  final ChangePassword changePassword;
  final DeleteAccount deleteAccount;
  final DownloadUserData downloadUserData;

  SettingsBloc({
    required this.getSettings,
    required this.saveSettings,
    required this.changePassword,
    required this.deleteAccount,
    required this.downloadUserData,
  }) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<ChangePasswordEvent>(_onChangePassword);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<DownloadUserDataEvent>(_onDownloadUserData);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    final result = await getSettings(NoParams());

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onSaveSettings(
    SaveSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentSettings = event.settings;

    emit(SettingsLoading());

    final result = await saveSettings(currentSettings);

    result.fold(
      (failure) {
        emit(SettingsLoaded(currentSettings));
        emit(SettingsError(failure.message));
      },
      (_) {
        emit(SettingsSaved());
        emit(SettingsLoaded(currentSettings));
      },
    );
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Instantly reflect toggle/selection changes in the UI
    emit(SettingsLoaded(event.settings));
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(PasswordChanging());

    final result = await changePassword(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(PasswordChanged()),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(AccountDeleting());

    final result = await deleteAccount(
      DeleteAccountParams(password: event.password),
    );

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(AccountDeleted()),
    );
  }

  Future<void> _onDownloadUserData(
    DownloadUserDataEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(DataDownloading());

    final result = await downloadUserData(NoParams());

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (data) => emit(DataDownloaded(data)),
    );
  }
}