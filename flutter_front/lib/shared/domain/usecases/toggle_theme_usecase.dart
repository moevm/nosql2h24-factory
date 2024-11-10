import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/theme/theme_service.dart';
import 'package:clean_architecture/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/usecases/usecase.dart';

class ToggleThemeUseCase implements UseCase <void, ThemeMode> {
  final SettingsRepository repository;

  ToggleThemeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(theme) async {
    await repository.setTheme(theme);
    return const Right(null);
  }
}