import 'package:clean_architecture/features/home/domain/entities/fetch_topics.dart';
import 'package:clean_architecture/features/home/presentation/bloc/home_bloc.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_entity.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';
import 'package:clean_architecture/shared/presentation/hover_effect.dart';
import 'package:clean_architecture/shared/presentation/mini_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../shared/data/models/minichart_data_model.dart';
import '../../../../shared/presentation/fade_in_wrapper.dart';
import '../../../../shared/presentation/hover_color_wrapper.dart';
import '../../../../shared/services/equipment_status.dart';
import 'minichart_settings.dart';

class EquipmentWidgetList extends StatelessWidget {
  final EquipmentListEntity equipmentList;
  final MiniChartDataModel chartsData;
  final Map<String, EquipmentStatus> statuses;

  const EquipmentWidgetList({
    super.key,
    required this.equipmentList,
    required this.chartsData,
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 20,
      runSpacing: 20,
        children: equipmentList.equipment.asMap().entries.map((entry) {
          final int index = entry.key;
          final EquipmentEntity equipment = entry.value;
          return FadeInWrapper(
            delayIndex: index,
            playOnce: true,
            child: EquipmentCard(
              equipment: equipment,
              chartData: chartsData.valuesOnly[equipment.key],
              status: statuses[equipment.key] ?? EquipmentStatus.turnOff,
            ),
          );
        }).toList(),
    );
  }
}

class EquipmentCard extends StatefulWidget {
  final EquipmentEntity equipment;
  final Map<String, Map<String, List<double>?>>? chartData;
  final EquipmentStatus status;

  const EquipmentCard({
    super.key,
    required this.equipment,
    this.chartData,
    required this.status
  });

  @override
  _EquipmentCardState createState() => _EquipmentCardState();
}

class _EquipmentCardState extends State<EquipmentCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeBloc>().state as HomeLoaded;
    final isCollapsed = homeState.collapsedEquipment.contains(widget.equipment.key);

    return SizedBox(
      width: 400, // Уменьшена ширина
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: HoverColorDecoration(
          isHovering: _isHovering,
          color: widget.status.color,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Изменено для выравнивания
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50, // Увеличена высота для двух строк
                          child: Text(
                            widget.equipment.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2, // Разрешаем перенос на две строки
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if(_isHovering) Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _collapseButton(widget.equipment),
                          _settingsButton(widget.equipment, widget.chartData),
                        ],
                      ) else const SizedBox(width: 75)
                    ],
                  ),
                  Row(
                    children: [
                      Text(widget.status.translate),
                      if (Theme.of(context).brightness != Brightness.dark)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: widget.status.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(height: 16),
                    _getMiniCharts(),
                    const SizedBox(height: 16),
                    Text('Общее время работы: ${widget.equipment.workingTime.allTime} ч.'),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _collapseButton(EquipmentEntity equipment) {
    final homeState = context.watch<HomeBloc>().state as HomeLoaded;
    final isCollapsed = homeState.collapsedEquipment.contains(equipment.key);

    return HoverScaleEffect(
      child: IconButton(
        icon: Icon(
          isCollapsed ? Icons.expand_more : Icons.expand_less,
          size: 18,
        ),
        onPressed: () {
          context.read<HomeBloc>().add(ToggleEquipmentCollapse(equipment.key));
        },
      ),
    );
  }

  Widget _getMiniCharts(){
    if(widget.chartData == null) return const SizedBox();
    List<Widget> res = [];
    widget.chartData!.forEach((paramKey, paramValue){
      widget.chartData![paramKey]!.forEach((subParamKey, arr){
        if(arr != null) {
          res.add(MiniChart(
              data: arr,
              title: widget.equipment.parameters[paramKey]?.translate ?? paramKey,
              unit: widget.equipment.parameters[paramKey]?.unit ?? 'у.е.',
              threshold: widget.equipment.parameters[paramKey]?.threshold));
        }
      });
    });
    return Column(children: res);
  }

  Widget _settingsButton(EquipmentEntity equipment, Map<String, Map<String, List<double>?>>? topics){
    return HoverScaleEffect(
      child: IconButton(
        icon: const Icon(
            Icons.settings,
          size: 18,
        ),
        onPressed: () => showMiniChartsSettingsDialog(context, equipment, topics),
      ),
    );
  }
}