import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class SaveSettings implements UseCase<void, Settings> {
  final SettingsRepository repository;

  SaveSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(Settings params) {
    return repository.saveSettings(params);
  }
}