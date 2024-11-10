import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../core/error/failure.dart';
import '../../../features/settings/domain/repositories/settings_repository.dart';

class GetThemeUseCase {
  final SettingsRepository repository;

  GetThemeUseCase(this.repository);

  Future<ThemeMode> call() async {
    return await repository.getTheme();
  }
}