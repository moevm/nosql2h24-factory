import 'package:clean_architecture/features/settings/domain/entities/settings_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/settings_model.dart';

abstract class SettingsRepository {
  Future<ThemeMode> getTheme();
  Future<Either<Failure, void>> setTheme(ThemeMode theme);
  Future<Either<Failure, void>> exportSettings(SettingsEntity settings);
  Future<Either<Failure, SettingsEntity>> importSettings();
}