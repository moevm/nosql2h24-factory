import 'package:clean_architecture/features/warnings/presentation/widgets/paggination_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../shared/presentation/equipment_selector/equipment_selector.dart';
import '../../../../shared/presentation/excess_percent_slider.dart';
import '../bloc/warnings_bloc.dart';

class WarningsControlPanel extends StatelessWidget {
  final WarningsLoaded state;
  final bool isExpanded;

  const WarningsControlPanel({
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
              child: Column(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildEquipmentSelector(context),
                      _buildExcessPercentSlider(context),
                      _buildDateRangeButton(context),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFiltersRow(context),
                  const SizedBox(height: 16),
                  PaginationControls(
                    currentPage: state.warningsData.page,
                    totalPages: state.warningsData.pages,
                    totalItems: state.warningsData.total,
                    onPageChanged: (page) => _onPageChanged(context, page),
                  ),
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
        equipment: state.warningsData.equipment.getKeysAndNames(),
        selectedEquipment: state.selectedEquipmentKey,
        onEquipmentChanged: (String? equipmentKey) => _onEquipmentChanged(context, equipmentKey),
      ),
    );
  }

  Widget _buildExcessPercentSlider(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ExcessPercentSlider(
        value: state.excessPercent,
        onChanged: (value) => _onExcessPercentChanged(context, value),
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

  Widget _buildFiltersRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 16, // Add spacing between elements
        runSpacing: 16, // Add spacing between rows
        alignment: WrapAlignment.center,
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text("По возрастанию"),
              ),
              ButtonSegment(
                value: false,
                label: Text("По убыванию"),
              ),
            ],
            selected: {state.orderAscending},
            onSelectionChanged: (Set<bool> selected) =>
                _onOrderChanged(context, selected.first),
          ),
          SegmentedButton<bool?>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text("Просмотрено"),
              ),
              ButtonSegment(
                value: null,
                label: Text("Все"),
              ),
              ButtonSegment(
                value: false,
                label: Text("Не просмотрено"),
              ),
            ],
            selected: {state.viewed},
            onSelectionChanged: (Set<bool?> selected) =>
                _onViewedFilterChanged(context, selected.first),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: state.withDescription,
                onChanged: (value) =>
                    _onWithDescriptionChanged(context, value ?? false),
              ),
              const Text("С описанием"),
            ],
          ),
        ],
      ),
    );
  }

  void _onOrderChanged(BuildContext context, bool ascending) {
    context.read<WarningsBloc>().add(FetchWarnings(
      page: state.warningsData.page,
      excessPercent: state.excessPercent,
      equipmentKey: state.selectedEquipmentKey,
      startDate: state.startDate,
      endDate: state.endDate,
      orderAscending: ascending,
      withDescription: state.withDescription,
      viewed: state.viewed,
    ));
  }

  void _onWithDescriptionChanged(BuildContext context, bool withDescription) {
    context.read<WarningsBloc>().add(FetchWarnings(
      page: state.warningsData.page,
      excessPercent: state.excessPercent,
      equipmentKey: state.selectedEquipmentKey,
      startDate: state.startDate,
      endDate: state.endDate,
      orderAscending: state.orderAscending,
      withDescription: withDescription,
      viewed: state.viewed,
    ));
  }

  void _onViewedFilterChanged(BuildContext context, bool? viewed) {
    context.read<WarningsBloc>().add(FetchWarnings(
      page: state.warningsData.page,
      excessPercent: state.excessPercent,
      equipmentKey: state.selectedEquipmentKey,
      startDate: state.startDate,
      endDate: state.endDate,
      orderAscending: state.orderAscending,
      withDescription: state.withDescription,
      viewed: viewed,
    ));
  }

  void _onEquipmentChanged(BuildContext context, String? equipmentKey) {
    context.read<WarningsBloc>().add(FetchWarnings(
      page: state.warningsData.page,
      excessPercent: state.excessPercent,
      equipmentKey: equipmentKey,
      startDate: state.startDate,
      endDate: state.endDate,
    ));
    context.read<WarningsBloc>().add(SaveSelectedEquipmentEvent(equipmentKey: equipmentKey));
  }

  void _onExcessPercentChanged(BuildContext context, double value) {
    context.read<WarningsBloc>().add(FetchWarnings(
      page: state.warningsData.page,
      excessPercent: value,
      equipmentKey: state.selectedEquipmentKey,
      startDate: state.startDate,
      endDate: state.endDate,
    ));
    context.read<WarningsBloc>().add(SaveExcessPercentEvent(excessPercent: value));
  }

  void _onPageChanged(BuildContext context, int page) {
    context.read<WarningsBloc>().add(FetchWarnings(
      page: page,
      excessPercent: state.excessPercent,
      equipmentKey: state.selectedEquipmentKey,
      startDate: state.startDate,
      endDate: state.endDate,
    ));
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: (state.startDate != null && state.endDate != null)
          ? DateTimeRange(start: state.startDate!, end: state.endDate!)
          : null,
    );
    if (result != null && context.mounted) {
      context.read<WarningsBloc>().add(SaveDateTimeRange(
        startDate: result.start,
        endDate: result.end,
      ));
    }
  }
}