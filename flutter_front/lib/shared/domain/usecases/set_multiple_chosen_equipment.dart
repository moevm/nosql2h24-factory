import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/hive_repository.dart';

class SetMultipleChosenEquipmentUseCase implements UseCase<void, List<String>?> {
  final HiveRepository repository;

  SetMultipleChosenEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(List<String>? equipment) async {
    return await repository.setMultipleChosenEquipment(equipment);
  }
}