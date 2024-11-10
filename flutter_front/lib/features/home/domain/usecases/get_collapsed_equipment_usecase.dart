import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:clean_architecture/shared/domain/usecases/no_params.dart';

class GetCollapsedEquipmentUseCase implements UseCase<List<String>, NoParams> {
  final HiveRepository hiveRepository;

  GetCollapsedEquipmentUseCase(this.hiveRepository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await hiveRepository.getCollapsedEquipment();
  }
}