import 'package:clean_architecture/features/statistics/data/models/warning_statistics.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/statistics.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, List<Statistics>>> getWarningStatistics({
    required DateTime startDate,
    required DateTime endDate,
    required String? equipment,
    required String groupBy,
    required String metric,
    required double excessPercent,
  });

  Future<Either<Failure, WarningStatisticsModel>> getEquipmentWarningsStatistics(Map<String, dynamic> params);
}