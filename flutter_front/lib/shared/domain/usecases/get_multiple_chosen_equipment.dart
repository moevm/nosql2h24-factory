import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/hive_repository.dart';
import 'no_params.dart';

class GetMultipleChosenEquipmentUseCase implements UseCase<List<String>?, NoParams> {
  final HiveRepository repository;

  GetMultipleChosenEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>?>> call(NoParams params) async {
    return await repository.getMultipleChosenEquipment();
  }
}