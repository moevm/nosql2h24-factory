// Сущность
import 'equipment_details_entity.dart';
import 'equipment_metadata_entity.dart';
import 'equipment_parametr_entity.dart';
import 'equipment_working_parametr_entity.dart';
import 'equipment_working_time_entity.dart';

class EquipmentEntity {
  final String id;
  final String key;
  final String name;
  final EquipmentDetailsEntity details;
  final Map<String, ParameterEntity> parameters;
  final WorkingParameterEntity? workingParameter;
  final MetadataEntity? metadata;
  final WorkingTimeEntity workingTime;

  EquipmentEntity({
    required this.id,
    required this.key,
    required this.name,
    required this.details,
    required this.parameters,
    this.workingParameter,
    required this.metadata,
    required this.workingTime,
  });
}