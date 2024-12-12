import 'package:clean_architecture/core/error/exception.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/shared/data/datasources/local/hive_datasource.dart';
import 'package:clean_architecture/shared/data/datasources/remote/equipment_datasource.dart';
import 'package:clean_architecture/shared/data/models/equipment/equipment_list_model.dart';
import 'package:clean_architecture/shared/data/models/equipment/equipment_model.dart';
import 'package:clean_architecture/shared/domain/repositories/equipment_repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/equipment/equipment_list_entity.dart';

class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentRemoteDataSource remoteDatasource;

  EquipmentRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, EquipmentListEntity>> getEquipment(
      {Map<String, dynamic>? params}) async {
    try {
      final equipment = await remoteDatasource.getEquipment(params: params);
      return Right(equipment.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}