import 'package:clean_architecture/features/settings/data/datasorces/settings_remote_data_source.dart';
import 'package:clean_architecture/features/settings/domain/entities/settings_entity.dart';
import 'package:clean_architecture/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/data/datasources/local/hive_datasource.dart';
import '../../../../shared/data/repositories/base_repository.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl extends BaseRepository implements SettingsRepository {
  final HiveLocalDataSource localDataSource;
  final SettingsRemoteDataSource remoteDataSource;
  final Failure failure = CacheFailure();

  SettingsRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<ThemeMode> getTheme() async {
    final res = await performNullableOperation(() {
      return localDataSource.getTheme();
    }, failure);
    return res.fold(
        (f) => ThemeMode.light,
        (theme) {
          if(theme == "dark") {
            return ThemeMode.dark;
          } else {
            return ThemeMode.light;
          }
        }
    );
  }

  @override
  Future<Either<Failure, void>> setTheme(ThemeMode theme) async {
    if (theme == ThemeMode.dark){
      await performNullableOperation(() => localDataSource.saveTheme("dark"), failure);
    } else {
      await performNullableOperation(() => localDataSource.saveTheme("light"), failure);
    }
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> exportSettings(SettingsEntity settings) async =>
    performOperation(() => remoteDataSource.exportSettings(
        SettingsModel.fromEntity(settings).toJson()), failure);

  @override
  Future<Either<Failure, SettingsEntity>> importSettings() async {
    final settingsRes = await performNonNullOperation(() => remoteDataSource.importSettings(), failure);
    return settingsRes.fold(
        (f) => Left(ServerFailure()),
        (settings) => Right(SettingsModel.fromJson(settings).toEntity())
    );
  }
}