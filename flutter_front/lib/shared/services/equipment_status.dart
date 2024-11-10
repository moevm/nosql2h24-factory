import 'package:flutter/material.dart';

enum EquipmentStatus {
  work,
  notWork,
  turnOn,
  turnOff;

  String get translate {
    switch (this) {
      case EquipmentStatus.work:
        return 'Работает';
      case EquipmentStatus.notWork:
        return 'Не работает';
      case EquipmentStatus.turnOn:
        return 'Включено';
      case EquipmentStatus.turnOff:
        return 'Выключено';
    }
  }

  Color get color {
    switch (this) {
      case EquipmentStatus.work:
        return Colors.green;
      case EquipmentStatus.notWork:
        return Colors.red;
      case EquipmentStatus.turnOn:
        return Colors.orange;
      case EquipmentStatus.turnOff:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case EquipmentStatus.work:
        return Icons.check_circle;
      case EquipmentStatus.notWork:
        return Icons.error;
      case EquipmentStatus.turnOn:
        return Icons.power;
      case EquipmentStatus.turnOff:
        return Icons.power_off;
    }
  }
}