part of 'warnings_bloc.dart';

abstract class WarningsState {
  final BottomMessage? message;
  const WarningsState({this.message});
}

class WarningsInitial extends WarningsState {}

class WarningsLoading extends WarningsState {}

class WarningsLoaded extends WarningsState {
  final WarningsData warningsData;
  final double excessPercent;
  final String? selectedEquipmentKey;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool orderAscending;
  final bool withDescription;
  final bool? viewed;

  WarningsLoaded({
    required this.warningsData,
    this.excessPercent = 0,
    this.selectedEquipmentKey,
    this.startDate,
    this.endDate,
    this.orderAscending = true,
    this.withDescription = false,
    this.viewed,
  });

  WarningsLoaded copyWith({
    WarningsData? warningsData,
    double? excessPercent,
    String? selectedEquipmentKey,
    DateTime? startDate,
    DateTime? endDate,
    bool? orderAscending,
    bool? withDescription,
    bool? viewed,
    BottomMessage? message,
  }) {
    return WarningsLoaded(
      warningsData: warningsData ?? this.warningsData,
      excessPercent: excessPercent ?? this.excessPercent,
      selectedEquipmentKey: selectedEquipmentKey ?? this.selectedEquipmentKey,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      orderAscending: orderAscending ?? this.orderAscending,
      withDescription: withDescription ?? this.withDescription,
      viewed: viewed ?? this.viewed,
    );
  }
}

class WarningsError extends WarningsState {
  String errorMessage;
  WarningsError(this.errorMessage);
}