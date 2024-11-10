import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/hive_repository.dart';

class SetExcessPercentUseCase implements UseCase<void, double> {
  final HiveRepository repository;

  SetExcessPercentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(double percent) async {
    return await repository.setExcessPercent(percent);
  }
}