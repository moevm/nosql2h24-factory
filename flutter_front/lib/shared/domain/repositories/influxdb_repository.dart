import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/features/home/domain/entities/fetch_topics.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/minichart_data_model.dart';
import '../../data/models/percentage_model.dart';

abstract class InfluxdbRepository {
  Future<Either<Failure, MiniChartDataModel>> getLiveChartsData(Map<String, dynamic> topics, String interval, String startTime, String endTime,
      {String aggregateFunction = 'mean'});
  Future<Either<Failure, List<double>>> getStatisticWorkingPercentage(Map<String, dynamic> body);
  Future<Either<Failure, PercentageModel>> getEquipmentWorkingPercentage(Map<String, dynamic> body);
}