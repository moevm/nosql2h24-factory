import 'package:flutter/material.dart';
import '../../domain/entities/chart_config.dart';

class AggregationControl extends StatelessWidget {
  final Set<AggregationType> selectedAggregations;
  final Function(Set<AggregationType>) onAggregationChanged;

  const AggregationControl({
    super.key,
    required this.selectedAggregations,
    required this.onAggregationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Функция агрегации',
            style: TextStyle(
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
                mainAxisSize: MainAxisSize.min,
                children: AggregationType.values.map((type) {
                  final isSelected = selectedAggregations.contains(type);
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            final newSelection = <AggregationType>{type};  // Создаем новое множество только с выбранным элементом
                            onAggregationChanged(newSelection);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getAggregationLabel(type),
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
      ),
    );
  }

  String _getAggregationLabel(AggregationType type) {
    switch (type) {
      case AggregationType.min:
        return 'Минимум';
      case AggregationType.max:
        return 'Максимум';
      case AggregationType.mean:
        return 'Среднее';
    }
  }
}