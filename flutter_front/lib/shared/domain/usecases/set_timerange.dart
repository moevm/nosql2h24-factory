import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/repositories/hive_repository.dart';
import '../../../core/error/failure.dart';

class SaveTimeRangeUseCase implements UseCase<void, DateTimeRange> {
  final HiveRepository repository;

  SaveTimeRangeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DateTimeRange params) async {
    return await repository.setDateTimeRange(params);
  }
}