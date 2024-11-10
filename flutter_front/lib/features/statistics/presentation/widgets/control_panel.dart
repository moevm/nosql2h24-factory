import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../shared/presentation/equipment_selector/equipment_selector.dart';
import '../../../../shared/presentation/excess_percent_slider.dart';
import '../bloc/statistics_bloc.dart';

class StatisticsControlPanel extends StatelessWidget {
  final StatisticsLoaded state;
  final bool isExpanded;

  const StatisticsControlPanel({
    super.key,
    required this.state,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isWide || isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildEquipmentSelector(context),
                  _buildExcessPercentSlider(context),
                  _buildDateRangeButton(context),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _buildEquipmentSelector(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: EquipmentSelector(
        equipment: state.equipmentList.getKeysAndNames(),
        selectedEquipment: state.selectedEquipmentKey,
        onEquipmentChanged: (String? equipmentKey) {
          context.read<StatisticsBloc>().add(
            SaveSelectedEquipmentEvent(equipmentKey: equipmentKey),
          );
        },
      ),
    );
  }

  Widget _buildExcessPercentSlider(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ExcessPercentSlider(
        value: state.excessPercent,
        onChanged: (value) {
          context.read<StatisticsBloc>().add(
            SaveExcessPercentEvent(excessPercent: value),
          );
        },
      ),
    );
  }

  Widget _buildDateRangeButton(BuildContext context) {
    return Column(
      children: [
        const Text("Период"),
        const SizedBox(height: 5),
        ElevatedButton.icon(
          icon: const Icon(Icons.date_range),
          label: _buildDateRangeText(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () => _showDateRangePicker(context),
        ),
      ],
    );
  }

  Widget _buildDateRangeText() {
    if (state.startDate != null && state.endDate != null) {
      return Text(
        '${DateFormat('dd.MM.yyyy').format(state.startDate!)} - ${DateFormat('dd.MM.yyyy').format(state.endDate!)}',
        style: const TextStyle(fontSize: 14),
      );
    }
    return const Text("Выберите даты");
  }

  void _showDateRangePicker(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: state.startDate ?? DateTime.now().subtract(const Duration(days: 7)),
      end: state.endDate ?? DateTime.now(),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
    );

    if (pickedDateRange != null) {
      context.read<StatisticsBloc>().add(
        SaveDateTimeRange(
          startDate: pickedDateRange.start,
          endDate: pickedDateRange.end,
        ),
      );
    }
  }
}