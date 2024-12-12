import 'package:clean_architecture/features/charts/presentation/widgets/parametr_selector.dart';
import 'package:clean_architecture/features/charts/presentation/widgets/time_range_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/entities/equipment/equipment_list_entity.dart';
import '../../../../shared/presentation/equipment_selector/multiple_equipment_selector.dart';
import '../../domain/entities/chart_config.dart';
import '../bloc/charts_bloc.dart';
import 'aggregation_control.dart';
import 'anomaly_warnings_control.dart';

class ChartsControlPanel extends StatelessWidget {
  final EquipmentListEntity equipmentList;
  final List<String>? selectedEquipmentKeys;
  final List<String>? selectedParameterKeys;
  final ChartConfiguration configuration;
  final Function(List<String>?) onEquipmentChanged;
  final Function(List<String>?) onParametersChanged;
  final Function(ChartConfiguration) onConfigurationChanged;
  final VoidCallback onFetchData;

  const ChartsControlPanel({
    super.key,
    required this.equipmentList,
    required this.selectedEquipmentKeys,
    required this.selectedParameterKeys,
    required this.configuration,
    required this.onEquipmentChanged,
    required this.onParametersChanged,
    required this.onConfigurationChanged,
    required this.onFetchData,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final commonParameters = equipmentList.getCommonParameters(
            selectedEquipmentKeys ?? []);

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 16,
              children: [
                SizedBox(
                  width: 200,
                  child: MultipleEquipmentSelector(
                    equipmentList: equipmentList,
                    selectedEquipmentKeys: selectedEquipmentKeys,
                    onChanged: onEquipmentChanged,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ParameterSelector(
                    parameters: commonParameters,
                    selectedParameterKeys: selectedParameterKeys,
                    onChanged: onParametersChanged,
                    isEnabled: selectedEquipmentKeys?.isNotEmpty ?? false,
                  ),
                ),
                // AnomalyWarningsControl(
                //   showWarnings: configuration.showWarnings,
                //   showAnomalies: configuration.showAnomalies,
                //   onWarningsChanged: (value) {
                //     onConfigurationChanged(
                //       configuration.copyWith(showWarnings: value),
                //     );
                //   },
                //   onAnomaliesChanged: (value) {
                //     onConfigurationChanged(
                //       configuration.copyWith(showAnomalies: value),
                //     );
                //   },
                // ),
                AggregationControl(
                  selectedAggregations: configuration.selectedAggregations,
                  onAggregationChanged: (value) {
                    onConfigurationChanged(
                      configuration.copyWith(selectedAggregations: value),
                    );
                  },
                ),
                TimeRangeSelector(
                  timeRange: configuration.timeRange,
                  customStartDate: configuration.customStartDate,
                  customEndDate: configuration.customEndDate,
                  realTime: configuration.realTime,
                  pointsDistance: configuration.pointsDistance,
                  onTimeRangeChanged: (timeRange) {
                    onConfigurationChanged(
                      configuration.copyWith(
                        timeRange: timeRange,
                        realTime: false,
                      ),
                    );
                  },
                  onCustomRangeChanged: (start, end) {
                    onConfigurationChanged(
                      configuration.copyWith(
                        customStartDate: start,
                        customEndDate: end,
                      ),
                    );
                  },
                  onRealTimeChanged: (value) {
                    onConfigurationChanged(
                      configuration.copyWith(realTime: value),
                    );
                  },
                  onPointsDistanceChanged: (distance) {
                    onConfigurationChanged(
                      configuration.copyWith(pointsDistance: distance),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: selectedEquipmentKeys?.isNotEmpty == true &&
                      selectedParameterKeys?.isNotEmpty == true
                      ? () {
                    context.read<ChartsBloc>().add(FetchChartsDataEvent());
                    onFetchData();
                  }
                      : null,
                  child: const Text('Получить данные'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}