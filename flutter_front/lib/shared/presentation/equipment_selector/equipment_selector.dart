// lib/features/warnings/presentation/widgets/multiple_equipment_selector.dart
import 'package:flutter/material.dart';

class EquipmentSelector extends StatelessWidget {
  final Map<String, String> equipment;
  final String? selectedEquipment;
  final Function(String?) onEquipmentChanged;

  const EquipmentSelector({
    super.key,
    required this.equipment,
    required this.selectedEquipment,
    required this.onEquipmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedEquipment,
      hint: const Text('Выберите оборудование'),
      isExpanded: true,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Все оборудование'),
        ),
        ...equipment.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }),
      ],
      onChanged: onEquipmentChanged,
    );
  }
}