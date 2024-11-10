import 'package:clean_architecture/core/error/exception.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/features/home/domain/entities/fetch_topics.dart';
import 'package:clean_architecture/shared/data/datasources/remote/influxdb_parser_datasource.dart';
import 'package:clean_architecture/shared/data/models/percentage_model.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/chart_point.dart';
import '../../domain/repositories/influxdb_repository.dart';
import '../models/minichart_data_model.dart';

class InfluxdbRepositoryImpl implements InfluxdbRepository {
  final InfluxdbParserRemoteDataSource remoteDataSource;

  InfluxdbRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MiniChartDataModel>> getLiveChartsData(Map<String, dynamic> topics, String interval, String startTime, String endTime,
      {String aggregateFunction = "mean"}) async {
    try {
      Map<String, dynamic> body = {
      "start_time": startTime,
      "end_time": endTime,
      "interval": interval,
      "aggregate_function": aggregateFunction,
      "equipments_parameters": topics,
    };
      final equipment = await remoteDataSource.getLiveCharts(body);
      return Right(equipment);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<double>>> getStatisticWorkingPercentage(Map<String, dynamic> body) async {
    try {
      final arr = await remoteDataSource.getStatisticWorkingPercentage(body);
      return Right(arr);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PercentageModel>> getEquipmentWorkingPercentage(Map<String, dynamic> body) async {
    try {
      final res = PercentageModel.fromJson(await remoteDataSource.getEquipmentWorkingPercentage(body));
      return Right(res);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}