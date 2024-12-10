import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeRangeSelector extends StatelessWidget {
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final Function(DateTime?, DateTime?) onDateTimeRangeChanged;

  const DateTimeRangeSelector({
    super.key,
    this.startDateTime,
    this.endDateTime,
    required this.onDateTimeRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

    return Column(
      children: [
        Text('Start: ${startDateTime != null ? formatter.format(startDateTime!) : 'Not set'}'),
        Text('End: ${endDateTime != null ? formatter.format(endDateTime!) : 'Not set'}'),
        ElevatedButton(
          child: const Text('Select Date and Time Range'),
          onPressed: () async {
            DateTimeRange? dateRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              initialDateRange: DateTimeRange(
                start: startDateTime ?? DateTime(2024, 11, 6),
                end: endDateTime ?? DateTime(2024, 11, 8),
              ),
            );

            if (dateRange != null) {
              TimeOfDay? startTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(startDateTime ?? DateTime.now()),
              );

              TimeOfDay? endTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(endDateTime ?? DateTime.now()),
              );

              if (startTime != null && endTime != null) {
                DateTime start = DateTime(
                  dateRange.start.year,
                  dateRange.start.month,
                  dateRange.start.day,
                  startTime.hour,
                  startTime.minute,
                );
                DateTime end = DateTime(
                  dateRange.end.year,
                  dateRange.end.month,
                  dateRange.end.day,
                  endTime.hour,
                  endTime.minute,
                );
                onDateTimeRangeChanged(start, end);
              }
            }
          },
        ),
      ],
    );
  }
}