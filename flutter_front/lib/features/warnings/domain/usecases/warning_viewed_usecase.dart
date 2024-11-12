import 'package:clean_architecture/features/warnings/domain/repositories/warnings_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/warning.dart';

class WarningViewedUseCase implements UseCase<void, WarningViewedParams>{
  final WarningsRepository repository;
  WarningViewedUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(WarningViewedParams params) async {
    return repository.warningsViewed(params.toMap());
  }
}

class WarningViewedParams {
  List<Warning> warnings;
  bool value;
  WarningViewedParams(this.warnings, this.value);

  Map<String, dynamic> toMap() {
    return {
      for (Warning warning in warnings) warning.id: value
    };
  }
}