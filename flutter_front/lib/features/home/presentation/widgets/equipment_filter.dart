import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import 'package:intl/intl.dart';

class EquipmentFilter extends StatefulWidget {
  const EquipmentFilter({super.key});

  @override
  State<EquipmentFilter> createState() => _EquipmentFilterState();
}

class _EquipmentFilterState extends State<EquipmentFilter> {
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _yearRangeController;
  late final TextEditingController _groupController;
  String? _selectedStatus;
  DateTimeRange? _selectedDateRange;

  final List<String> _statusOptions = [
    'В работе',
    'Не работает',
    'В ремонте',
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<HomeBloc>().state;
    final Map<String, dynamic> currentFilters = (state is HomeLoaded)
        ? state.currentFilters
        : {};

    _nameController = TextEditingController(text: currentFilters['name'] ?? '');
    _locationController = TextEditingController(text: currentFilters['location'] ?? '');
    _yearRangeController = TextEditingController(text: currentFilters['year'] ?? '');
    _groupController = TextEditingController(text: currentFilters['group'] ?? '');
    _selectedStatus = currentFilters['status'];

    if (currentFilters['year'] != null) {
      final yearRange = currentFilters['year'].toString().split('-');
      if (yearRange.length == 2) {
        _selectedDateRange = DateTimeRange(
          start: DateTime(int.parse(yearRange[0])),
          end: DateTime(int.parse(yearRange[1])),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _yearRangeController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  Future<void> _selectYearRange() async {
    final now = DateTime.now();
    final initialYear = _selectedDateRange?.start.year ?? now.year;

    final startYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите начальный год'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: DateTime(now.year),
              selectedDate: DateTime(initialYear),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime.year);
              },
            ),
          ),
        );
      },
    );

    if (startYear != null) {
      final endYear = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Выберите конечный год'),
            content: SizedBox(
              width: 300,
              height: 300,
              child: YearPicker(
                firstDate: DateTime(startYear),
                lastDate: DateTime(now.year),
                selectedDate: DateTime(startYear),
                onChanged: (DateTime dateTime) {
                  Navigator.pop(context, dateTime.year);
                },
              ),
            ),
          );
        },
      );

      if (endYear != null) {
        setState(() {
          _selectedDateRange = DateTimeRange(
            start: DateTime(startYear),
            end: DateTime(endYear),
          );
          _yearRangeController.text = '$startYear-$endYear';
        });
      }
    }
  }

  Map<String, dynamic> _getFilterParams() {
    final params = <String, dynamic>{};

    if (_nameController.text.isNotEmpty) {
      params['name'] = _nameController.text;
    }
    if (_locationController.text.isNotEmpty) {
      params['location'] = _locationController.text;
    }
    if (_selectedStatus != null && _selectedStatus != 'Не выбрано') {
      params['status'] = _selectedStatus;
    }
    if (_yearRangeController.text.isNotEmpty) {
      params['year'] = _yearRangeController.text;
    }
    if (_groupController.text.isNotEmpty) {
      params['group'] = _groupController.text;
    }

    return params;
  }

  void _onSearch() {
    context.read<HomeBloc>().add(
      FilterEquipment(_getFilterParams()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Название',
                      border: UnderlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Местоположение',
                      border: UnderlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus ?? 'Не выбрано',
                    decoration: const InputDecoration(
                      labelText: 'Глобальный статус',
                      border: UnderlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: 'Не выбрано',
                        child: Text('Не выбрано'),
                      ),
                      ..._statusOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue == 'Не выбрано' ? null : newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _yearRangeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Диапазон годов',
                      border: UnderlineInputBorder(),
                      isDense: true,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: _selectYearRange,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _groupController,
                    decoration: const InputDecoration(
                      labelText: 'Группа',
                      border: UnderlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: _onSearch,
                    child: const Text('Найти'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}