
import 'package:clean_architecture/shared/domain/entities/percentage_entity.dart';
import 'package:clean_architecture/shared/domain/repositories/influxdb_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/influx_formater.dart';
import '../../../../core/usecases/usecase.dart';

class GetEquipmentWorkingPercentage implements UseCase<PercentageEntity, GetEquipmentWorkingPercentageParams> {
  final InfluxdbRepository repository;

  GetEquipmentWorkingPercentage(this.repository);

  @override
  Future<Either<Failure, PercentageEntity>> call(GetEquipmentWorkingPercentageParams params) async {
    final res = await repository.getEquipmentWorkingPercentage(params.toMap());
    return res.fold((f) => Left(f),
        (percent) => Right(percent.toEntity())
    );
  }
}

class GetEquipmentWorkingPercentageParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String? equipment;

  const GetEquipmentWorkingPercentageParams({
    required this.startDate,
    required this.endDate,
    required this.equipment,
  });

  Map<String, dynamic> toMap() => {
    'start_time': formatDateTimeForInflux(startDate),
    'end_time': formatDateTimeForInflux(endDate),
    'equipment': equipment,
  };

  @override
  List<Object?> get props => [startDate, endDate, equipment];
}