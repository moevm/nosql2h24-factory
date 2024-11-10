import 'equipment_subparametr_entity.dart';

class ParameterEntity {
  final String translate;
  final String unit;
  final double? threshold;
  final Map<String, SubParameterEntity> subparameters;

  ParameterEntity({
    required this.translate,
    required this.unit,
    this.threshold,
    required this.subparameters,
  });
}