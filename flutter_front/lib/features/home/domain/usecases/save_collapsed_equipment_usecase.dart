import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:dartz/dartz.dart';

class SaveCollapsedEquipmentUseCase implements UseCase<void, List<String>> {
  final HiveRepository hiveRepository;

  SaveCollapsedEquipmentUseCase(this.hiveRepository);

  @override
  Future<Either<Failure, void>> call(List<String> params) async {
    return await hiveRepository.saveCollapsedEquipment(params);
  }
}