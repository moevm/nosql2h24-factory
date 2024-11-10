part of 'statistics_bloc.dart';

abstract class StatisticsEvent {}

class InitializeStatistics extends StatisticsEvent {}

class FetchStatistics extends StatisticsEvent {
  final double excessPercent;
  final String? equipmentKey;
  final DateTime? startDate;
  final DateTime? endDate;

  FetchStatistics({
    required this.excessPercent,
    this.equipmentKey,
    this.startDate,
    this.endDate,
  });
}

class SaveDateTimeRange extends StatisticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  SaveDateTimeRange({required this.startDate, required this.endDate});
}

class SaveExcessPercentEvent extends StatisticsEvent {
  final double excessPercent;

  SaveExcessPercentEvent({required this.excessPercent});
}

class SaveSelectedEquipmentEvent extends StatisticsEvent {
  final String? equipmentKey;

  SaveSelectedEquipmentEvent({required this.equipmentKey});
}

class UpdateGroupBy extends StatisticsEvent {
  final StatisticsGroupBy groupBy;
  UpdateGroupBy({required this.groupBy});
}

class UpdateMetric extends StatisticsEvent {
  final StatisticsMetric metric;
  UpdateMetric({required this.metric});
}