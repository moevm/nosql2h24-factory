import 'package:clean_architecture/shared/data/models/minichart_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/repositories/influxdb_repository.dart';
import 'init_chart_data.dart';

class UpdateChartDataUseCase implements UseCase<InitChartData, InitChartData> {
  final InfluxdbRepository influxRepository;

  UpdateChartDataUseCase(this.influxRepository);

  @override
  Future<Either<Failure, InitChartData>> call(InitChartData chartData) async {
    final res = await influxRepository.getLiveChartsData(chartData.settings.toMap(), '3s', '-3s', "now()");

    return res.fold((error) => Left(ServerFailure()), (data) {
      chartData.data = chartData.data.updateWithNewData(data);
      return Right(chartData);
    });
  }
}
