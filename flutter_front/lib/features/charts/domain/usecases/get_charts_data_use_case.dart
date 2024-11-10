import 'package:clean_architecture/features/charts/domain/entities/chart_config.dart';
import 'package:clean_architecture/shared/data/models/minichart_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/influx_formater.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/repositories/influxdb_repository.dart';

class GetChartsDataUseCase implements UseCase<MiniChartDataModel, GetChartsDataUseCaseParams> {
  final InfluxdbRepository influxRepository;

  GetChartsDataUseCase(this.influxRepository);

  @override
  Future<Either<Failure, MiniChartDataModel>> call(GetChartsDataUseCaseParams params) async {
    final res = await influxRepository.getLiveChartsData(
        params.topics,
        params.getInterval(),
        params.getStart(),
        params.getEnd());
    return res.fold((f) => Left(f),
        (data) => Right(data));
  }
}

class GetChartsDataUseCaseParams{
  final TimeRange period;
  final DateTime start;
  final DateTime end;
  final Duration interval;

  final Map<String, dynamic> topics;
  GetChartsDataUseCaseParams({
    required this.period,
    required this.start,
    required this.end,
    required this.interval,
    required this.topics
  });

  String getStart() {
    if(period == TimeRange.custom) return formatDateTimeForInflux(start);
    return getInfluxString(period);
  }

  String getEnd() {
    if(period == TimeRange.custom) return formatDateTimeForInflux(end);
    return "now()";
  }

  String getInterval() {
    return '${interval.inSeconds}s';
  }
}