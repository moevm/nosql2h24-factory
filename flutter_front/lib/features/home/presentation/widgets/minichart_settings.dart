import 'package:clean_architecture/core/theme/theme_service.dart';
import 'package:clean_architecture/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/data/models/minichart_data_model.dart';
import '../../../../shared/domain/entities/equipment/equipment_entity.dart';
import '../../domain/entities/fetch_topics.dart';

void showMiniChartsSettingsDialog(BuildContext context, EquipmentEntity equipment, Map<String, Map<String, List<double>?>>? topics) async {
  final homeBloc = context.read<HomeBloc>();

  final result = await showDialog<UpdatedMiniChartsSettings>(
    context: context,
    builder: (BuildContext context) {
      return MiniChartsSettingsDialog(equipment: equipment, topics: topics);
    },
  );

  if (result != null) {
    homeBloc.add(UpdateChartSettings(result));
  }
}

class MiniChartsSettingsDialog extends StatefulWidget {
  final EquipmentEntity equipment;
  final Map<String, Map<String, List<double>?>>? topics;

  const MiniChartsSettingsDialog({super.key, required this.equipment, required this.topics});

  @override
  _MiniChartsSettingsDialogState createState() => _MiniChartsSettingsDialogState();
}

class _MiniChartsSettingsDialogState extends State<MiniChartsSettingsDialog> {
  Map<String, Map<String, bool>> selectedParameters = {};
  bool applyForAll = false;

  @override
  void initState() {
    super.initState();
    for (var parameter in widget.equipment.parameters.entries) {
      selectedParameters[parameter.key] = {};
      for (var subParameter in parameter.value.subparameters.entries) {
        bool status = false;
        if(widget.topics?[parameter.key]?[subParameter.key] != null){
          status = true;
        }
        selectedParameters[parameter.key]![subParameter.key] = status;
      }
    }
  }

  bool isLockedParameter(String parameterKey, String subParameterKey, EquipmentEntity equipment) {
    final p1 = (parameterKey == 'temperature' && subParameterKey == 'temperature_out');
    final p2 = equipment.workingParameter?.name != null &&
        parameterKey == equipment.workingParameter!.name &&
        subParameterKey == equipment.workingParameter!.name;
    return p1 || p2;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Настройки мини-графиков для ${widget.equipment.name}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            ...widget.equipment.parameters.entries.map((parameter) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parameter.value.translate, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ...parameter.value.subparameters.entries.map((subParameter) {
                    final isLocked = isLockedParameter(parameter.key, subParameter.key, widget.equipment);
                    return ListTile(
                      title: Text(subParameter.value.translate),
                      leading: isLocked
                          ? const Icon(Icons.lock, size: 24, color: Colors.green,)
                          : Checkbox(
                        value: selectedParameters[parameter.key]![subParameter.key],
                        onChanged: (bool? value) {
                          if (!isLocked) {
                            setState(() {
                              selectedParameters[parameter.key]![subParameter.key] = value!;
                            });
                          }
                        },
                      ),
                    );
                  }),
                  const Divider(),
                ],
              );
            }).toList(),
            CheckboxListTile(
              title: Text('Применить ко всем'),
              value: applyForAll,
              onChanged: (bool? value) {
                setState(() {
                  applyForAll = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Сохранить'),
          onPressed: () {
            Map<String, List<String>> settings = {};
            for (var parameter in selectedParameters.entries) {
              settings[parameter.key] = parameter.value.entries
                  .where((subParameter) => subParameter.value || isLockedParameter(parameter.key, subParameter.key, widget.equipment))
                  .map((subParameter) => subParameter.key)
                  .toList();
            }
            Navigator.of(context).pop(
              UpdatedMiniChartsSettings(widget.equipment, settings, applyForAll),
            );
          },
        ),
      ],
    );
  }
}