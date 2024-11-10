import 'dart:ffi';

import 'package:clean_architecture/features/statistics/data/models/warning_statistics.dart';
import 'package:clean_architecture/features/statistics/domain/entities/warning_statistics_entity.dart';
import 'package:clean_architecture/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:clean_architecture/shared/domain/repositories/influxdb_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/influx_formater.dart';
import '../../../../core/usecases/usecase.dart';

class GetEquipmentWarningsStatistics implements UseCase<WarningStatisticsEntity, GetEquipmentWarningsStatisticsParams> {
  final StatisticsRepository repository;

  GetEquipmentWarningsStatistics(this.repository);

  @override
  Future<Either<Failure, WarningStatisticsEntity>> call(GetEquipmentWarningsStatisticsParams params) async {
    final res = await repository.getEquipmentWarningsStatistics(params.toMap());
    return res.fold(
            (f) => Left(f),
        (model) => Right(model.toEntity()));
  }
}

class GetEquipmentWarningsStatisticsParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String? equipment;
  const GetEquipmentWarningsStatisticsParams({
    required this.startDate,
    required this.endDate,
    required this.equipment,
  });

  Map<String, dynamic> toMap() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    return {
      'start_date': formatDateTimeForInflux(startDate),
      'end_date': formatDateTimeForInflux(endDate),
      'equipment': equipment,
    };
  }

  @override
  List<Object?> get props => [startDate, endDate, equipment];
}