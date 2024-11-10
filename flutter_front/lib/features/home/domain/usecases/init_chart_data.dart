import 'package:clean_architecture/features/home/domain/entities/fetch_topics.dart';
import 'package:clean_architecture/shared/data/datasources/local/hive_datasource.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_entity.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:clean_architecture/shared/domain/repositories/influxdb_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/data/models/minichart_data_model.dart';

class InitializeChartDataUseCase implements UseCase<InitChartData, EquipmentListEntity> {
  final HiveRepository hiveRepository;
  final InfluxdbRepository influxRepository;

  InitializeChartDataUseCase(this.hiveRepository, this.influxRepository);

  @override
  Future<Either<Failure, InitChartData>> call(EquipmentListEntity equipment) async {
    final localData = await hiveRepository.getMiniChartsTopics();
    late FetchMiniChartsTopics settings;
    localData.fold(
            (exception) => settings = createMiniChartsSettings(equipment),
            (data) => settings = data
    );

    final chartData = await influxRepository.getLiveChartsData(settings.toMap(), '3s', '-5m', "now()");
    return chartData.fold(
        (e) => Left(ServerFailure()),
        (data) => Right(InitChartData(data, settings))
    );
  }

  FetchMiniChartsTopics createMiniChartsSettings(EquipmentListEntity equipment){
    FetchMiniChartsTopics settings = FetchMiniChartsTopics(equipment: []);
    for(EquipmentEntity equip in equipment.equipment){
      settings.equipment.add(EquipmentMiniChart(name: equip.key, params: []));
      if(equip.workingParameter != null){
        final param = equip.workingParameter!.name;
        final supParam= param;
        final subParamExist = equip.parameters[param]?.subparameters[supParam];
        if(subParamExist != null) {
          settings.equipment.last.params.add(
              ParameterMiniChart(name: param, subParams: [supParam]));
        }
        final tempTopic = equip.parameters["temperature"]?.subparameters["temperature_out"];
        if(tempTopic != null) {
          settings.equipment.last.params.add(
              ParameterMiniChart(name: "temperature", subParams: ["temperature_out"]));
        }
      }

    }
    hiveRepository.saveMiniChartsTopics(settings);
    return settings;
  }
}

class InitChartData{
  MiniChartDataModel data;
  FetchMiniChartsTopics settings;

  InitChartData(this.data, this.settings);
}