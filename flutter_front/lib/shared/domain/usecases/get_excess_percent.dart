import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/hive_repository.dart';
import 'no_params.dart';

class GetExcessPercentUseCase implements UseCase<double?, NoParams> {
  final HiveRepository repository;

  GetExcessPercentUseCase(this.repository);

  @override
  Future<Either<Failure, double?>> call(NoParams params) async {
    return await repository.getExcessPercent();
  }
}