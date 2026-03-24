import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/settings.dart';
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
    emit(SettingsLoading());

    final result = await saveSettings(event.settings);

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(SettingsSaved()),
    );
  }
}