import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/src/material/date.dart';

import '../../../core/error/failure.dart';
import '../../../features/home/domain/entities/fetch_topics.dart';
import '../datasources/local/hive_datasource.dart';
import 'base_repository.dart';

class HiveRepositoryImpl extends BaseRepository implements HiveRepository {
  final HiveLocalDataSource localDataSource;
  final Failure failure = CacheFailure();

  HiveRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> initializeUserBox(String username) =>
      performOperation(() => localDataSource.initializeUserBox(username), failure);

  // User

  @override
  Future<Either<Failure, void>> saveUsername(String user) =>
      performOperation(() => localDataSource.saveUsername(user), failure);

  @override
  Future<Either<Failure, String?>> getUsername() =>
      performNullableOperation(() => localDataSource.getUsername(), failure);

  // Logo

  @override
  Future<Either<Failure, void>> saveLogo(String logo) =>
      performOperation(() => localDataSource.saveLogo(logo), failure);

  @override
  Future<Either<Failure, String?>> getLogo() =>
      performNullableOperation(() => localDataSource.getLogo(), failure);

  // Token

  @override
  Future<Either<Failure, void>> saveToken(String token) =>
      performOperation(() => localDataSource.saveToken(token), failure);

  @override
  Future<Either<Failure, String>> getToken() =>
      performNonNullOperation(() => localDataSource.getToken(), failure);

  // Refresh token

  @override
  Future<Either<Failure, void>> saveRefreshToken(String token) =>
      performOperation(() => localDataSource.saveRefreshToken(token), failure);

  @override
  Future<Either<Failure, String>> getRefreshToken() =>
      performNonNullOperation(() => localDataSource.getRefreshToken(), failure);

  // Mini Charts

  @override
  Future<Either<Failure, void>> saveMiniChartsTopics(FetchMiniChartsTopics topics) =>
      performOperation(() => localDataSource.saveMiniChartsTopics(topics), failure);

  @override
  Future<Either<Failure, FetchMiniChartsTopics>> getMiniChartsTopics() =>
      performNonNullOperation(() => localDataSource.getMiniChartsTopics(), failure);


  // Chosen Datetime period
  @override
  Future<Either<Failure, DateTimeRange>> getDateTimeRange() =>
    performNonNullOperation(() => localDataSource.getPeriod(), failure);


  @override
  Future<Either<Failure, void>> setDateTimeRange(DateTimeRange timeRange) =>
      performOperation(() => localDataSource.savePeriod(timeRange), failure);

  // Collapsed equip on main page

  @override
  Future<Either<Failure, List<String>>> getCollapsedEquipment() =>
      performNonNullOperation(() => localDataSource.getCollapsedEquipment(), failure);

  @override
  Future<Either<Failure, void>> saveCollapsedEquipment(List<String> collapsedKeys) =>
      performOperation(() => localDataSource.saveCollapsedEquipment(collapsedKeys), failure);

  // Chosen Equipment

  @override
  Future<Either<Failure, String?>> getChosenEquipment() =>
      performNullableOperation(() => localDataSource.getChosenEquipment(), failure);

  @override
  Future<Either<Failure, void>> setChosenEquipment(String? equipment) =>
      performOperation(() => localDataSource.saveChosenEquipment(equipment), failure);

  // Chosen Equipment

  @override
  Future<Either<Failure, List<String>?>> getMultipleChosenEquipment() =>
      performNullableOperation(() => localDataSource.getMultipleChosenEquipment(), failure);

  @override
  Future<Either<Failure, void>> setMultipleChosenEquipment(List<String>? equipment) =>
      performOperation(() => localDataSource.saveMultipleChosenEquipment(equipment), failure);

  // Excess Percent

  @override
  Future<Either<Failure, double?>> getExcessPercent() =>
      performNullableOperation(() => localDataSource.getExcessPercent(), failure);

  @override
  Future<Either<Failure, void>> setExcessPercent(double percent) =>
      performOperation(() => localDataSource.saveExcessPercent(percent), failure);

}