import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/hive_repository.dart';

class SetChosenEquipmentUseCase implements UseCase<void, String?> {
  final HiveRepository repository;

  SetChosenEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String? equipment) async {
    return await repository.setChosenEquipment(equipment);
  }
}