import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';

class FileHandlerWidget extends StatelessWidget {
  const FileHandlerWidget({super.key});

  void _handleFileExport(BuildContext context) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..multiple = true
      ..accept = '.txt';

    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        context.read<SettingsBloc>().add(ExportFilesEvent(files));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 16,
        direction: Axis.vertical,
        children: [
          const Text("Импорт/экспорт данных",
              style: TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            onPressed: () {
              context.read<SettingsBloc>().add(ImportFilesEvent());
            },
            icon: const Icon(Icons.download),
            label: const Text('Экспорт данных'),
          ),
          ElevatedButton.icon(
            onPressed: () => _handleFileExport(context),
            icon: const Icon(Icons.upload),
            label: const Text('Импорт данных'),
          ),
          const Text("Необходимо 2 txt файла", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}