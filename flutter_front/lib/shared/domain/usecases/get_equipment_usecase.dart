import 'package:clean_architecture/shared/data/models/equipment/equipment_list_model.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/equipment_repository.dart';
import '../repositories/hive_repository.dart';
import 'no_params.dart';

class GetEquipmentUseCase implements UseCase<EquipmentListEntity, NoParams> {
  final EquipmentRepository repository;

  GetEquipmentUseCase(this.repository);

  @override
  Future<Either<Failure, EquipmentListEntity>> call(NoParams params) async {
    return await repository.getEquipment();
  }
}