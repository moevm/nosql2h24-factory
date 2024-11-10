import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/hive_repository.dart';
import 'no_params.dart';

class GetChosenEquipmentUseCase implements UseCase<String?, NoParams> {
  final HiveRepository repository;

  GetChosenEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await repository.getChosenEquipment();
  }
}