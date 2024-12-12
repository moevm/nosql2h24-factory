import 'package:clean_architecture/features/warnings/presentation/widgets/warning_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/warnings_bloc.dart';

Future<void> showDescriptionDialog(BuildContext context, WarningsBloc bloc, WarningListItem widget) async {
  final oldString = widget.warning.description?.text ?? '';
  final TextEditingController controller = TextEditingController(
    text: oldString,
  );
  bool hasChanges = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: bloc,
        child: BlocListener<WarningsBloc, WarningsState>(
          listenWhen: (previous, current) =>
          current is WarningsLoaded &&
              current.message != null &&
              !current.message!.isError,
          listener: (context, state) {
            Navigator.of(context).pop();
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Информация о предупреждении'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${widget.warning.id}'),
                      const SizedBox(height: 8),
                      Text('Дата: ${DateFormat('dd.MM.yyyy').format(widget.warning.date)}'),
                      const SizedBox(height: 8),
                      Text('Период: ${DateFormat('dd.MM.yyyy').format(widget.warning.dateFrom)} - ${DateFormat('dd.MM.yyyy').format(widget.warning.dateTo)}'),
                      const SizedBox(height: 8),
                      Text('Оборудование: ${widget.warning.equipment}'),
                      const SizedBox(height: 8),
                      Text('Превышение: ${widget.warning.excessPercent.toStringAsFixed(2)}%'),
                      const SizedBox(height: 8),
                      Text('Текст: ${widget.warning.text}'),
                      const SizedBox(height: 8),
                      Text('Тип: ${widget.warning.type}'),
                      const SizedBox(height: 8),
                      Text('Значение: ${widget.warning.value}'),
                      const SizedBox(height: 8),
                      Text('Статус: ${widget.warning.viewed ? "Просмотрено" : "Не просмотрено"}'),
                      const SizedBox(height: 16),
                      const Text('Описание:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Введите описание...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          setState(() {
                            hasChanges = value != oldString;
                          });
                        },
                      ),
                      if(widget.warning.description != null)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text("Добавлено: ${widget.warning.description!.author}"),
                            Text("Дата: ${DateFormat('dd.MM.yyyy HH:mm').format(widget.warning.description!.updated)}"),
                          ],
                        )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Закрыть'),
                  ),
                  TextButton(
                    onPressed: hasChanges
                        ? () {
                      bloc.add(UpdateWarningDescription(
                        widget.warning,
                        controller.text,
                      ));
                    }
                        : null,
                    child: const Text('Сохранить'),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}