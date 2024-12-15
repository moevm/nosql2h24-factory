import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/shared/data/models/equipment/equipment_model.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/equipment/equipment_list_model.dart';

abstract class EquipmentRepository {
  Future<Either<Failure, EquipmentListEntity>> getEquipment(
      {Map<String, dynamic>? params});
}