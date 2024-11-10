part of 'statistics_bloc.dart';

abstract class StatisticsState {
  final BottomMessage? message;
  const StatisticsState({this.message});
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsFetching extends StatisticsState {
  final StatisticsLoaded lastState;

  StatisticsFetching(this.lastState);
}

class StatisticsLoaded extends StatisticsState {
  final List<Statistics> statistics;
  final double excessPercent;
  final String? selectedEquipmentKey;
  final StatisticsGroupBy selectedGroupBy;
  final StatisticsMetric selectedMetric;
  final EquipmentListEntity equipmentList;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<double> workPercentage;
  final PercentageEntity? equipmentPercent;
  final WarningStatisticsEntity? warningStatistics; // Добавленное поле

  StatisticsLoaded({
    this.statistics = const [],
    this.excessPercent = 0,
    this.selectedEquipmentKey,
    this.selectedGroupBy = StatisticsGroupBy.day,
    this.selectedMetric = StatisticsMetric.count,
    required this.equipmentList,
    this.workPercentage = const [],
    this.startDate,
    this.endDate,
    this.equipmentPercent,
    this.warningStatistics, // Добавлено в конструктор
    super.message,
  });

  StatisticsLoaded copyWith({
    List<Statistics>? statistics,
    double? excessPercent,
    Optional<String?>? selectedEquipmentKey,
    StatisticsGroupBy? selectedGroupBy,
    StatisticsMetric? selectedMetric,
    EquipmentListEntity? equipmentList,
    DateTime? startDate,
    DateTime? endDate,
    BottomMessage? message,
    List<double>? workPercentage,
    PercentageEntity? equipmentPercent,
    WarningStatisticsEntity? warningStatistics, // Добавлено в copyWith
  }) {
    return StatisticsLoaded(
      statistics: statistics ?? this.statistics,
      excessPercent: excessPercent ?? this.excessPercent,
      selectedEquipmentKey: selectedEquipmentKey != null ? selectedEquipmentKey.value : this.selectedEquipmentKey,
      selectedGroupBy: selectedGroupBy ?? this.selectedGroupBy,
      selectedMetric: selectedMetric ?? this.selectedMetric,
      equipmentList: equipmentList ?? this.equipmentList,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      message: message ?? this.message,
      workPercentage: workPercentage ?? this.workPercentage,
      equipmentPercent: equipmentPercent ?? this.equipmentPercent,
      warningStatistics: warningStatistics ?? this.warningStatistics, // Добавлено
    );
  }
}

class StatisticsError extends StatisticsState {
  final String errorMessage;
  StatisticsError(this.errorMessage);
}