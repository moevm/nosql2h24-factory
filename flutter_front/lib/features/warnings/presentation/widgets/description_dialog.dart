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
                title: const Text('Добавить описание'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        children: [
                          Text("Добавлено ${widget.warning.description!.author}"),
                          Text(DateFormat('MM/dd HH:mm').format(widget.warning.description!.updated)),
                        ],
                      )
                  ],
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