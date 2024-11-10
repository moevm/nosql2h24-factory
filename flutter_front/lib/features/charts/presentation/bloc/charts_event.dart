// charts_event.dart
part of 'charts_bloc.dart';

abstract class ChartsEvent {}

class InitializeCharts extends ChartsEvent {}

class SaveSelectedEquipmentEvent extends ChartsEvent {
  final List<String>? equipmentKeys;
  SaveSelectedEquipmentEvent({required this.equipmentKeys});
}

class SaveSelectedParametersEvent extends ChartsEvent {
  final List<String>? parameterKeys;
  SaveSelectedParametersEvent({required this.parameterKeys});
}

class UpdateChartConfigurationEvent extends ChartsEvent {
  final ChartConfiguration configuration;
  UpdateChartConfigurationEvent(this.configuration);
}

class FetchChartsDataEvent extends ChartsEvent {}
class FetchRealTimeDataEvent extends ChartsEvent {}