import 'package:flutter/material.dart';
import '../../domain/entities/chart_config.dart';

class TimeRangeSelector extends StatelessWidget {
  final TimeRange timeRange;
  final DateTime customStartDate;
  final DateTime customEndDate;
  final bool realTime;
  final Duration pointsDistance;
  final Function(TimeRange) onTimeRangeChanged;
  final Function(DateTime?, DateTime?) onCustomRangeChanged;
  final Function(bool) onRealTimeChanged;
  final Function(Duration) onPointsDistanceChanged;

  const TimeRangeSelector({
    super.key,
    required this.timeRange,
    required this.customStartDate,
    required this.customEndDate,
    required this.realTime,
    required this.pointsDistance,
    required this.onTimeRangeChanged,
    required this.onCustomRangeChanged,
    required this.onRealTimeChanged,
    required this.onPointsDistanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final availableIntervals = _calculateAvailableIntervals();
    final currentPointsDistance = availableIntervals.contains(pointsDistance)
        ? pointsDistance
        : availableIntervals.first;

    if (currentPointsDistance != pointsDistance) {
      // Если текущее значение недоступно, устанавливаем первое доступное
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onPointsDistanceChanged(currentPointsDistance);
      });
    }

    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Временной диапазон',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: DropdownButton<TimeRange>(
                value: timeRange,
                isExpanded: true,
                onChanged: (TimeRange? newValue) {
                  if (newValue != null) {
                    onTimeRangeChanged(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(value: TimeRange.day, child: Text('1 день')),
                  DropdownMenuItem(value: TimeRange.halfDay, child: Text('12 часов')),
                  DropdownMenuItem(value: TimeRange.hour, child: Text('1 час')),
                  DropdownMenuItem(value: TimeRange.fifteenMinutes, child: Text('15 минут')),
                  DropdownMenuItem(value: TimeRange.custom, child: Text('Свой период')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        if (timeRange == TimeRange.custom)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildCustomRangePicker(context),
          ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Интервал между точками',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: DropdownButton<Duration>(
                value: currentPointsDistance,
                isExpanded: true,
                onChanged: (Duration? newValue) {
                  if (newValue != null) {
                    onPointsDistanceChanged(newValue);
                  }
                },
                items: availableIntervals
                    .map((interval) => DropdownMenuItem(
                  value: interval,
                  child: Text(_formatDuration(interval)),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
        if (timeRange != TimeRange.custom)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: [
                const Text('Real time'),
                const SizedBox(height: 8),
                Switch(
                  value: realTime,
                  onChanged: onRealTimeChanged,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCustomRangePicker(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: Text(customStartDate.toIso8601String()),
          onPressed: () => _showDatePicker(context, true),
        ),
        const SizedBox(width: 16),
        TextButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: Text(customEndDate.toIso8601String()),
          onPressed: () => _showDatePicker(context, false),
        ),
      ],
    );
  }

  List<Duration> _calculateAvailableIntervals() {
    final totalDuration = _calculateTotalDuration();
    const maxPoints = 2000;

    final minInterval = Duration(
      milliseconds: totalDuration.inMilliseconds ~/ maxPoints,
    );

    final intervals = <Duration>{
      const Duration(seconds: 1),
      const Duration(seconds: 5),
      const Duration(seconds: 15),
      const Duration(seconds: 30),
      const Duration(minutes: 1),
      const Duration(minutes: 5),
      const Duration(minutes: 15),
      const Duration(minutes: 30),
      const Duration(hours: 1),
      const Duration(days: 1),
      const Duration(days: 7),
    };

    return intervals
        .where((interval) => (interval >= minInterval && interval <= totalDuration))
        .toList()
      ..sort();
  }

  Duration _calculateTotalDuration() {
    switch (timeRange) {
      case TimeRange.day:
        return const Duration(days: 1);
      case TimeRange.halfDay:
        return const Duration(hours: 12);
      case TimeRange.hour:
        return const Duration(hours: 1);
      case TimeRange.fifteenMinutes:
        return const Duration(minutes: 15);
      case TimeRange.custom:
        return customEndDate.difference(customStartDate);
    }
  }

  String _formatDuration(Duration duration) {
    if(duration.inDays == 7){
      return "1 нед";
    }
    if (duration.inHours > 0) {
      return '${duration.inHours} ч';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes} мин';
    }
    return '${duration.inSeconds} сек';
  }

  Future<void> _showDatePicker(BuildContext context, bool isStart) async {
    final initialDate = isStart ? customStartDate : customEndDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (time != null) {
        final DateTime selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );

        if (isStart) {
          onCustomRangeChanged(selectedDateTime, customEndDate);
        } else {
          onCustomRangeChanged(customStartDate, selectedDateTime);
        }
      }
    }
  }
}