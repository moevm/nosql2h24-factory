
import 'package:clean_architecture/shared/domain/repositories/influxdb_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/influx_formater.dart';
import '../../../../core/usecases/usecase.dart';

class GetStatisticWorkingPercentageUseCase implements UseCase<List<double>, GetStatisticWorkingPercentageParams> {
  final InfluxdbRepository repository;

  GetStatisticWorkingPercentageUseCase(this.repository);

  @override
  Future<Either<Failure, List<double>>> call(GetStatisticWorkingPercentageParams params) async {
    return await repository.getStatisticWorkingPercentage(params.toMap());
  }
}

class GetStatisticWorkingPercentageParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String? equipment;
  final String groupBy;

  const GetStatisticWorkingPercentageParams({
    required this.startDate,
    required this.endDate,
    required this.equipment,
    required this.groupBy,
  });

  Map<String, dynamic> toMap() => {
    'start_time': formatDateTimeForInflux(startDate),
    'end_time': formatDateTimeForInflux(endDate),
    'group_by': groupBy,
    'equipment': equipment,
  };

  @override
  List<Object?> get props => [startDate, endDate, equipment, groupBy];
}