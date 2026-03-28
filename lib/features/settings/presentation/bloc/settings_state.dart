import 'package:equatable/equatable.dart';
import '../../domain/entities/settings.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsSaved extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Password Change States ──────────────────────────────────────────────────

class PasswordChanging extends SettingsState {}

class PasswordChanged extends SettingsState {}

// ── Account Deletion States ─────────────────────────────────────────────────

class AccountDeleting extends SettingsState {}

class AccountDeleted extends SettingsState {}

// ── Data Download States ────────────────────────────────────────────────────

class DataDownloading extends SettingsState {}

class DataDownloaded extends SettingsState {
  final Map<String, dynamic> data;

  const DataDownloaded(this.data);

  @override
  List<Object?> get props => [data];
}