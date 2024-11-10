import 'package:clean_architecture/shared/domain/entities/equipment/equipment_entity.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/data/datasources/local/hive_datasource.dart';
import '../../../../shared/domain/repositories/influxdb_repository.dart';
import '../entities/fetch_topics.dart';
import 'init_chart_data.dart';

class UpdateMiniChartSettingsUseCase implements UseCase<InitChartData, UpdateMiniChartSettingsParams> {
  final HiveRepository hiveRepository;
  final InfluxdbRepository influxRepository;

  UpdateMiniChartSettingsUseCase(this.hiveRepository, this.influxRepository);

  @override
  Future<Either<Failure, InitChartData>> call(UpdateMiniChartSettingsParams params) async {
    FetchMiniChartsTopics settings;
    if(params.settings.forAll) {
      settings = FetchMiniChartsTopics(equipment: []);
      for (EquipmentEntity equip in params.equipment.equipment) {
        settings.equipment.add(EquipmentMiniChart(name: equip.key, params: []));
        params.settings.settings.forEach((paramKey, paramValue) {
          settings.equipment.last.params
              .add(ParameterMiniChart(name: paramKey, subParams: paramValue));
        });
      }
    } else {
      final ind = params.topics.equipment.indexWhere((e) => e.name == params.settings.equipment.key);
      params.topics.equipment[ind] = EquipmentMiniChart(name: params.settings.equipment.key, params: []);
      params.settings.settings.forEach((paramKey, paramValue) {
        params.topics.equipment[ind].params
            .add(ParameterMiniChart(name: paramKey, subParams: paramValue));
      });
      settings = params.topics;
    }

    await hiveRepository.saveMiniChartsTopics(settings);
    final newChartData = await influxRepository.getLiveChartsData(settings.toMap(), '3s', '-5m', "now()");
    return newChartData.fold(
            (e) => Left(ServerFailure()),
            (data) => Right(InitChartData(data, settings))
    );
  }
}

class UpdateMiniChartSettingsParams {
  UpdatedMiniChartsSettings settings;
  EquipmentListEntity equipment;
  FetchMiniChartsTopics topics;

  UpdateMiniChartSettingsParams(this.settings, this.equipment, this.topics);
}
