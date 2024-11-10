import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/features/settings/domain/entities/settings_entity.dart';
import 'package:clean_architecture/features/settings/domain/repositories/settings_repository.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:clean_architecture/shared/domain/usecases/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/usecases/usecase.dart';

class ImportSettingsUseCase implements UseCase<ThemeMode?, NoParams>{
  final SettingsRepository settingsRepository;
  final HiveRepository hiveRepository;

  ImportSettingsUseCase(this.settingsRepository, this.hiveRepository);
  @override
  Future<Either<Failure, ThemeMode?>> call(NoParams params) async {
    final settingsRes = await settingsRepository.importSettings();
    return settingsRes.fold(
        (f) => Left(f),
        (settings) async {
          if(settings.miniChartsTopics != null) await hiveRepository.saveMiniChartsTopics(settings.miniChartsTopics!);
          if(settings.theme != null) await settingsRepository.setTheme(settings.theme!);
          if(settings.collapsedEquipment != null) await hiveRepository.saveCollapsedEquipment(settings.collapsedEquipment!);
          return Right(settings.theme);
        }
    );
  }
}