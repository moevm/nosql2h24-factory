import 'package:clean_architecture/features/statistics/domain/entities/statistics.dart';
import 'package:clean_architecture/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';

class GetWarningStatisticsUseCase implements UseCase<List<Statistics>, GetWarningStatisticsParams> {
  final StatisticsRepository repository;

  GetWarningStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Statistics>>> call(GetWarningStatisticsParams params) async {
    return await repository.getWarningStatistics(
      startDate: params.startDate,
      endDate: params.endDate,
      equipment: params.equipment,
      groupBy: params.groupBy,
      metric: params.metric,
      excessPercent: params.excessPercent
    );
  }
}

class GetWarningStatisticsParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String? equipment;
  final String groupBy;
  final String metric;
  final double excessPercent;

  const GetWarningStatisticsParams({
    required this.startDate,
    required this.endDate,
    required this.equipment,
    required this.groupBy,
    required this.metric,
    required this.excessPercent,
  });

  @override
  List<Object?> get props => [startDate, endDate, equipment, groupBy, metric];
}