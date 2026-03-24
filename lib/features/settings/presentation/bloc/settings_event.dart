import 'package:equatable/equatable.dart';
import '../../domain/entities/settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {
  final Settings settings;

  const SaveSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}