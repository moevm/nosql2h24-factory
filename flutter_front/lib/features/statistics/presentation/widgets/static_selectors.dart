import 'package:flutter/material.dart';

import '../../data/models/statistics_model.dart';

class StatisticsSelectors extends StatelessWidget {
  final StatisticsGroupBy selectedGroupBy;
  final StatisticsMetric selectedMetric;
  final Function(StatisticsGroupBy) onGroupByChanged;
  final Function(StatisticsMetric) onMetricChanged;

  const StatisticsSelectors({
    super.key,
    required this.selectedGroupBy,
    required this.selectedMetric,
    required this.onGroupByChanged,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          children: [
            _buildSegmentedControl(
                title: 'Группировка (ось x)',
                items: StatisticsGroupBy.values,
                selectedItem: selectedGroupBy,
                onChanged: onGroupByChanged,
                getLabel: (item) => item.label,
                buttonColor: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            _buildSegmentedControl(
                title: 'Метрика превышения (ось y)',
                items: StatisticsMetric.values,
                selectedItem: selectedMetric,
                onChanged: onMetricChanged,
                getLabel: (item) => item.label,
                buttonColor: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl<T>(
      {required String title,
      required List<T> items,
      required T selectedItem,
      required Function(T) onChanged,
      required String Function(T) getLabel,
      required Color buttonColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.map((item) {
                final isSelected = item == selectedItem;
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => onChanged(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? buttonColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            getLabel(item),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
