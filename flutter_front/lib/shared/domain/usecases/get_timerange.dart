import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/repositories/hive_repository.dart';
import '../../../core/error/failure.dart';
import 'no_params.dart';

class GetTimeRangeUseCase implements UseCase<DateTimeRange, NoParams> {
  final HiveRepository repository;

  GetTimeRangeUseCase(this.repository);

  @override
  Future<Either<Failure, DateTimeRange>> call(NoParams params) async {
    return await repository.getDateTimeRange();
  }
}