import 'package:clean_architecture/features/statistics/domain/entities/warning_statistics_entity.dart';
import 'package:flutter/material.dart';
import '../../../../shared/domain/entities/percentage_entity.dart';

class WorkingPercentageCard extends StatefulWidget {
  final PercentageEntity? percentages;
  final WarningStatisticsEntity? warnings;
  final String? equipmentName;

  const WorkingPercentageCard({
    super.key,
    this.percentages,
    this.equipmentName,
    this.warnings,
  });

  @override
  State<WorkingPercentageCard> createState() => _WorkingPercentageCardState();
}

class _WorkingPercentageCardState extends State<WorkingPercentageCard> {
  bool _showInitialAnimation = true;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _showInitialAnimation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.percentages == null) return const SizedBox.shrink();

    final sortedTypes = PercentageType.values.toList()
      ..sort((a, b) => _getPercentageValue(b).compareTo(_getPercentageValue(a)));

    final maxType = sortedTypes.first;
    final maxPercentage = _getPercentageValue(maxType);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          // Основной контент
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.equipmentName ?? 'Все оборудование',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMainPercentage(
                            context: context,
                            type: maxType,
                            percentage: maxPercentage,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: sortedTypes.skip(1).map((type) =>
                                _buildSecondaryPercentage(
                                  context: context,
                                  type: type,
                                  percentage: _getPercentageValue(type),
                                )
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTotalCount(context),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTimeStats(context),
                              const SizedBox(width: 24),
                              _buildPercentStats(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Анимированный оверлей
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _showInitialAnimation ? 1.0 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: maxType.color.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        maxType.pastTranslation,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${maxPercentage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPercentage({
    required BuildContext context,
    required PercentageType type,
    required double percentage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: type.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              type.pastTranslation,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: type.color,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryPercentage({
    required BuildContext context,
    required PercentageType type,
    required double percentage,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: type.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${type.pastTranslation}: ${percentage.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTotalCount(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Количество предупреждений',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.warnings!.totalCount.toString(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'По времени',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildStatRow('Среднее:', widget.warnings!.duration.avgFormatted, context),
        _buildStatRow('Максимум:', widget.warnings!.duration.maxFormatted, context),
        _buildStatRow('Минимум:', widget.warnings!.duration.minFormatted, context),
        _buildStatRow('Общее:', widget.warnings!.duration.totalFormatted, context),
      ],
    );
  }

  Widget _buildPercentStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'По проценту',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildStatRow('Среднее:', widget.warnings!.excessPercent.avgFormatted, context),
        _buildStatRow('Максимум:', widget.warnings!.excessPercent.maxFormatted, context),
        _buildStatRow('Минимум:', widget.warnings!.excessPercent.minFormatted, context),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.8),
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  double _getPercentageValue(PercentageType type) {
    switch (type) {
      case PercentageType.work:
        return widget.percentages!.work;
      case PercentageType.turnOn:
        return widget.percentages!.turnOn;
      case PercentageType.turnOff:
        return widget.percentages!.turnOff;
      case PercentageType.notWork:
        return widget.percentages!.notWork;
    }
  }
}