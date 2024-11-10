// charts_state.dart
part of 'charts_bloc.dart';

abstract class ChartsState {
  final BottomMessage? message;
  ChartsState({this.message});
}

class ChartsInitial extends ChartsState {}

class ChartsLoading extends ChartsState {}

class ChartsSavingEquipment extends ChartsState {
  final ChartsLoaded previousState;
  ChartsSavingEquipment(this.previousState);
}

class ChartsFetchingData extends ChartsState {
  final ChartsLoaded previousState;
  ChartsFetchingData(this.previousState);
}

class ChartsError extends ChartsState {
  final String errorMessage;
  ChartsError(this.errorMessage);
}

class ChartsLoaded extends ChartsState {
  final EquipmentListEntity equipmentList;
  final List<String>? selectedEquipmentKeys;
  final List<String>? selectedParameterKeys;
  final ChartConfiguration configuration;
  final MiniChartDataModel? chartData;  // Add this
  final BottomMessage? message;

  ChartsLoaded({
    required this.equipmentList,
    this.selectedEquipmentKeys,
    this.selectedParameterKeys,
    required this.configuration,
    this.chartData,  // Add this
    this.message,
  });

  // Update copyWith method accordingly
  ChartsLoaded copyWith({
    Optional<List<String>>? selectedEquipmentKeys,
    Optional<List<String>>? selectedParameterKeys,
    ChartConfiguration? configuration,
    MiniChartDataModel? chartData,  // Add this
    BottomMessage? message,
  }) {
    return ChartsLoaded(
      equipmentList: equipmentList,
      selectedEquipmentKeys: selectedEquipmentKeys?.value ?? this.selectedEquipmentKeys,
      selectedParameterKeys: selectedParameterKeys?.value ?? this.selectedParameterKeys,
      configuration: configuration ?? this.configuration,
      chartData: chartData ?? this.chartData,  // Add this
      message: message,
    );
  }
}