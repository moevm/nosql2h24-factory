import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/features/settings/domain/entities/settings_entity.dart';
import 'package:clean_architecture/shared/domain/usecases/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/repositories/hive_repository.dart';
import '../repositories/settings_repository.dart';

class ExportSettingsUseCase implements UseCase<void, NoParams>{
  final SettingsRepository settingsRepository;
  final HiveRepository hiveRepository;
  ExportSettingsUseCase(this.settingsRepository, this.hiveRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final theme = await settingsRepository.getTheme();
    final miniChartsRes = await hiveRepository.getMiniChartsTopics();
    final collapsedRes = await hiveRepository.getCollapsedEquipment();
    return miniChartsRes.fold((f) => Left(f),
        (miniCharts) async {
          return collapsedRes.fold(
              (f) => Left(f),
              (collapsed) async {
                final settings = SettingsEntity(
                    theme: theme,
                    miniChartsTopics: miniCharts,
                    collapsedEquipment: collapsed
                );
                return await settingsRepository.exportSettings(settings);
              }
          );
        });
  }
}