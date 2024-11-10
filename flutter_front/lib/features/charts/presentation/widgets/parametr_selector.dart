import 'package:flutter/material.dart';
import '../../../../../shared/domain/entities/equipment/equipment_parametr_entity.dart';

class ParameterSelector extends StatefulWidget {
  final Map<String, ParameterEntity> parameters;
  final List<String>? selectedParameterKeys;
  final Function(List<String>?) onChanged;
  final bool isEnabled;

  const ParameterSelector({
    super.key,
    required this.parameters,
    required this.selectedParameterKeys,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  State<ParameterSelector> createState() => _ParameterSelectorState();
}

class _ParameterSelectorState extends State<ParameterSelector> {
  List<String> currentSelection = [];

  @override
  void initState() {
    super.initState();
    currentSelection = List<String>.from(widget.selectedParameterKeys ?? []);
  }

  @override
  void didUpdateWidget(ParameterSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedParameterKeys != widget.selectedParameterKeys) {
      currentSelection = List<String>.from(widget.selectedParameterKeys ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Параметры',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        MenuAnchor(
          builder: (context, controller, child) {
            return InkWell(
              onTap: widget.isEnabled
                  ? () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              }
                  : null,
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.isEnabled
                            ? null
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color:
                      widget.isEnabled ? null : Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            );
          },
          menuChildren: widget.isEnabled
              ? [
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.parameters.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(
                          '${entry.value.translate} (${entry.value.unit})'),
                      value: currentSelection.contains(entry.key),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            currentSelection.add(entry.key);
                          } else {
                            currentSelection.remove(entry.key);
                          }
                        });
                        widget.onChanged(
                            currentSelection.isEmpty ? null : currentSelection);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ]
              : [],
        ),
      ],
    );
  }

  String _getDisplayText() {
    if (!widget.isEnabled) {
      return 'Выберите оборудование';
    }
    if (currentSelection.isEmpty) {
      return 'Выберите параметры';
    }
    return 'Выбрано: ${currentSelection.length}';
  }
}