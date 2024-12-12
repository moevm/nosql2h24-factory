import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';

class EquipmentFilter extends StatefulWidget {
  const EquipmentFilter({super.key});

  @override
  State<EquipmentFilter> createState() => _EquipmentFilterState();
}

class _EquipmentFilterState extends State<EquipmentFilter> {
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _statusController;
  late final TextEditingController _yearController;
  late final TextEditingController _groupController;
  String? _yearError;

  @override
  void initState() {
    super.initState();
    final state = context.read<HomeBloc>().state;
    final Map<String, dynamic> currentFilters = (state is HomeLoaded)
        ? state.currentFilters
        : {};

    _nameController = TextEditingController(text: currentFilters['name'] ?? '');
    _locationController = TextEditingController(text: currentFilters['location'] ?? '');
    _statusController = TextEditingController(text: currentFilters['status'] ?? '');
    _yearController = TextEditingController(text: currentFilters['year']?.toString() ?? '');
    _groupController = TextEditingController(text: currentFilters['group'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _statusController.dispose();
    _yearController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  bool _validateYear() {
    if (_yearController.text.isEmpty) {
      setState(() => _yearError = null);
      return true;
    }

    final year = int.tryParse(_yearController.text);
    if (year == null) {
      setState(() => _yearError = 'Введите целое число');
      return false;
    }

    setState(() => _yearError = null);
    return true;
  }

  Map<String, dynamic> _getFilterParams() {
    final params = <String, dynamic>{};

    if (_nameController.text.isNotEmpty) {
      params['name'] = _nameController.text;
    }
    if (_locationController.text.isNotEmpty) {
      params['location'] = _locationController.text;
    }
    if (_statusController.text.isNotEmpty) {
      params['status'] = _statusController.text;
    }
    if (_yearController.text.isNotEmpty) {
      params['year'] = _yearController.text;
    }
    if (_groupController.text.isNotEmpty) {
      params['group'] = _groupController.text;
    }

    return params;
  }

  void _onSearch() {
    if (_validateYear()) {
      context.read<HomeBloc>().add(
        FilterEquipment(_getFilterParams()),
      );
    }
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
                  child: TextField(
                    controller: _statusController,
                    decoration: const InputDecoration(
                      labelText: 'Глобальный статус',
                      border: UnderlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Год',
                      border: const UnderlineInputBorder(),
                      isDense: true,
                      errorText: _yearError,
                    ),
                    onChanged: (_) => _validateYear(),
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