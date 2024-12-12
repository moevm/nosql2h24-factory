part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadHomePage extends HomeEvent {}

class UpdateChartData extends HomeEvent {}

class UpdateChartSettings extends HomeEvent {
  UpdatedMiniChartsSettings newSettings;

  UpdateChartSettings(this.newSettings);
}

class ToggleEquipmentCollapse extends HomeEvent {
  final String equipmentKey;

  ToggleEquipmentCollapse(this.equipmentKey);
}

class FilterEquipment extends HomeEvent {
  final Map<String, dynamic> filterParams;
  FilterEquipment(this.filterParams);
}
