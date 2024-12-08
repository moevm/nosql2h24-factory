import 'package:clean_architecture/features/statistics/domain/entities/statistics.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/influx_formater.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../data_source/statistics_datasource.dart';
import '../models/statistics_model.dart';
import '../models/warning_statistics.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsDatasource datasource;

  StatisticsRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<Statistics>>> getWarningStatistics({
    required DateTime startDate,
    required DateTime endDate,
    required String? equipment,
    required String groupBy,
    required String metric,
    required double excessPercent,
  }) async {
    try {
      final params = {
        'start_date': formatDateTimeForInflux(startDate, format: "local"),
        'end_date': formatDateTimeForInflux(endDate, format: "local"),
        'equipment': equipment,
        'group_by': groupBy,
        'metric': metric,
        'excess_percent': excessPercent.toString(),
      };

      final result = await datasource.getWarningStatistics(params);
      return Right(StatisticsModel.toEntityList(result));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, WarningStatisticsModel>> getEquipmentWarningsStatistics(Map<String, dynamic> params) async {
    try {
      final res = await datasource.getEquipmentWarningsStatistics(params);
      return Right(WarningStatisticsModel.fromJson(res));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}