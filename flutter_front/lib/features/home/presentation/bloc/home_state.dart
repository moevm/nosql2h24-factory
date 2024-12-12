// home_state.dart
part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String? logo;
  final EquipmentListEntity equipment;
  final MiniChartDataModel charts;
  final FetchMiniChartsTopics settings;
  final Map<String, EquipmentStatus> statuses;
  final int workNum;
  final double? maxTemperature;
  final List<String> collapsedEquipment;
  final Map<String, dynamic> currentFilters;

  HomeLoaded(
      this.logo,
      this.equipment,
      this.charts,
      this.settings,
      this.statuses,
      this.workNum,
      this.maxTemperature, {
        this.collapsedEquipment = const [],
        this.currentFilters = const {},
      });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
