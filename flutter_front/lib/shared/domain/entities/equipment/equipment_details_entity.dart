class EquipmentDetailsEntity {
  final String serialNumber;
  final String location;
  final String manufacturer;
  final String model;
  final String status;
  final int year;
  final String group;

  EquipmentDetailsEntity({
    required this.serialNumber,
    required this.location,
    required this.manufacturer,
    required this.model,
    required this.status,
    required this.year,
    required this.group,
  });
}