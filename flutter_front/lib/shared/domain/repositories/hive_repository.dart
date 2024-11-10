
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/error/failure.dart';
import '../../../features/home/domain/entities/fetch_topics.dart';
import '../../data/models/user_model.dart';

abstract class HiveRepository {
  Future<Either<Failure, void>> initializeUserBox(String username);

  // User
  Future<Either<Failure, void>> saveUsername(String user);

  Future<Either<Failure, String?>> getUsername();

  // Logo

  Future<Either<Failure, void>> saveLogo(String logo);

  Future<Either<Failure, String?>> getLogo();

  // Token

  Future<Either<Failure, void>> saveToken(String token);

  Future<Either<Failure, String>> getToken();

  // Refresh token

  Future<Either<Failure, void>> saveRefreshToken(String token);

  Future<Either<Failure, String>> getRefreshToken();

  // Mini Charts

  Future<Either<Failure, void>> saveMiniChartsTopics(FetchMiniChartsTopics topics);

  Future<Either<Failure, FetchMiniChartsTopics>> getMiniChartsTopics();

  // Chosen Datetime period

  Future<Either<Failure, DateTimeRange>> getDateTimeRange();
  Future<Either<Failure, void>> setDateTimeRange(DateTimeRange timeRange);

  // Collapsed equip on main page

  Future<Either<Failure, List<String>>> getCollapsedEquipment();
  Future<Either<Failure, void>> saveCollapsedEquipment(List<String> collapsedKeys);

  // Chosen Equipment
  Future<Either<Failure, String?>> getChosenEquipment();
  Future<Either<Failure, void>> setChosenEquipment(String? equipment);

  // Multiple Chosen Equipment
  Future<Either<Failure, List<String>?>> getMultipleChosenEquipment();
  Future<Either<Failure, void>> setMultipleChosenEquipment(List<String>? equipment);

  // Excess Percent
  Future<Either<Failure, double?>> getExcessPercent();
  Future<Either<Failure, void>> setExcessPercent(double percent);
}