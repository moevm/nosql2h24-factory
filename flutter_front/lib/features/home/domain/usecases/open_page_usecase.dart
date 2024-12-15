// get_home_page_data_usecase.dart

import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/shared/data/models/equipment/equipment_list_model.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_entity.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:clean_architecture/shared/domain/repositories/equipment_repository.dart';
import 'package:dartz/dartz.dart';

class HomePageData {
  final String? logo;
  final EquipmentListEntity equipment;

  HomePageData({required this.logo, required this.equipment});
}

class HomePageParams {
  final Map<String, dynamic>? filterParams;

  HomePageParams({this.filterParams});
}

class GetHomePageDataUseCase implements UseCase<HomePageData, HomePageParams> {
  final HiveRepository hiveRepository;
  final EquipmentRepository equipmentRepository;

  GetHomePageDataUseCase(this.hiveRepository, this.equipmentRepository);

  @override
  Future<Either<Failure, HomePageData>> call(HomePageParams params) async {
    final logoResult = await hiveRepository.getLogo();
    final equipmentResult = await equipmentRepository.getEquipment(
      params: params.filterParams,
    );

    return logoResult.fold(
          (logoFailure) => Left(ServerFailure()),
          (logo) => equipmentResult.fold(
            (equipmentFailure) => Left(ServerFailure()),
            (equipment) => Right(HomePageData(
          logo: logo,
          equipment: equipment,
        )),
      ),
    );
  }
}