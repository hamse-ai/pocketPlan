import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final SaveSettings saveSettings;

  SettingsBloc({
    required this.getSettings,
    required this.saveSettings,
  }) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
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
    // Keep a reference to the current settings so we can restore
    // SettingsLoaded after the save — otherwise the UI loses its state.
    final currentSettings = event.settings;

    emit(SettingsLoading());

    final result = await saveSettings(currentSettings);

    result.fold(
      (failure) {
        // On failure, restore the loaded state so the user's changes aren't
        // wiped from the screen.
        emit(SettingsLoaded(currentSettings));
        emit(SettingsError(failure.message));
      },
      (_) {
        // Signal success briefly, then immediately restore SettingsLoaded
        // so tabs that depend on SettingsLoaded keep rendering correctly.
        emit(SettingsSaved());
        emit(SettingsLoaded(currentSettings));
      },
    );
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Instantly reflect toggle/selection changes in the UI without
    // touching the data layer.
    emit(SettingsLoaded(event.settings));
  }
}
