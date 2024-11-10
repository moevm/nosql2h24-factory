part of 'warnings_bloc.dart';

abstract class WarningsEvent {}

class InitializeWarnings extends WarningsEvent {}

class FetchWarnings extends WarningsEvent {
  final int page;
  final double excessPercent;
  final String? equipmentKey;
  final DateTime? startDate;
  final DateTime? endDate;

  final bool orderAscending;
  final bool withDescription;
  final bool? viewed;

  FetchWarnings({
    required this.page,
    required this.excessPercent,
    this.equipmentKey,
    this.startDate,
    this.endDate,
    this.orderAscending = true,
    this.withDescription = false,
    this.viewed
  });
}

class SaveDateTimeRange extends WarningsEvent {
  final DateTime startDate;
  final DateTime endDate;

  SaveDateTimeRange({required this.startDate, required this.endDate});
}

class SaveExcessPercentEvent extends WarningsEvent {
  final double excessPercent;

  SaveExcessPercentEvent({required this.excessPercent});
}

class SaveSelectedEquipmentEvent extends WarningsEvent {
  final String? equipmentKey;

  SaveSelectedEquipmentEvent({required this.equipmentKey});
}

class MarkWarningAsViewed extends WarningsEvent {
  final Warning warning;

  MarkWarningAsViewed(this.warning);
}


class ToggleWarningViewed extends WarningsEvent {
  final Warning warning;
  final bool viewed;

  ToggleWarningViewed(this.warning, this.viewed);
}

class UpdateWarningDescription extends WarningsEvent {
  final Warning warning;
  final String text;

  UpdateWarningDescription(this.warning, this.text);
}