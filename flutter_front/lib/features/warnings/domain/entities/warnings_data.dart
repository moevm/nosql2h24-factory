import 'package:clean_architecture/features/warnings/domain/entities/warning.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';

import '../../../../shared/data/models/equipment/equipment_list_model.dart';

class WarningsData {
  final int page;
  final int pages;
  final int perPage;
  final int total;
  final List<Warning> warnings;

  late EquipmentListEntity equipment;

  WarningsData({
    required this.page,
    required this.pages,
    required this.perPage,
    required this.total,
    required this.warnings,
  });

  WarningsData copyWith({
    int? page,
    int? pages,
    int? perPage,
    int? total,
    List<Warning>? warnings,
    EquipmentListEntity? equipment,
  }) {
    final warningsData = WarningsData(
      page: page ?? this.page,
      pages: pages ?? this.pages,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      warnings: warnings ?? this.warnings,
    );
    warningsData.equipment = equipment ?? this.equipment;
    return warningsData;
  }
}