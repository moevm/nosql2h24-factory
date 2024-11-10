import 'package:flutter/material.dart';
import '../../../../../shared/domain/entities/equipment/equipment_list_entity.dart';

class MultipleEquipmentSelector extends StatefulWidget {
  final EquipmentListEntity equipmentList;
  final List<String>? selectedEquipmentKeys;
  final Function(List<String>?) onChanged;

  const MultipleEquipmentSelector({
    super.key,
    required this.equipmentList,
    required this.selectedEquipmentKeys,
    required this.onChanged,
  });

  @override
  State<MultipleEquipmentSelector> createState() => _EquipmentSelectorState();
}

class _EquipmentSelectorState extends State<MultipleEquipmentSelector> {
  List<String> currentSelection = [];

  @override
  void initState() {
    super.initState();
    currentSelection = List<String>.from(widget.selectedEquipmentKeys ?? []);
  }

  @override
  void didUpdateWidget(MultipleEquipmentSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedEquipmentKeys != widget.selectedEquipmentKeys) {
      currentSelection = List<String>.from(widget.selectedEquipmentKeys ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Оборудование',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        MenuAnchor(
          builder: (context, controller, child) {
            return InkWell(
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _getDisplayText(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            );
          },
          menuChildren: [
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.equipmentList.equipment.map((equipment) {
                    return CheckboxListTile(
                      title: Text(equipment.name),
                      value: currentSelection.contains(equipment.key),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            currentSelection.add(equipment.key);
                          } else {
                            currentSelection.remove(equipment.key);
                          }
                        });
                        widget.onChanged(currentSelection.isEmpty ? null : currentSelection);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getDisplayText() {
    if (currentSelection.isEmpty) {
      return 'Все оборудование';
    }
    return 'Выбрано: ${currentSelection.length}';
  }
}