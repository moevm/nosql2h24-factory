import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:convert';

class FileHandlerWidget extends StatelessWidget {
  const FileHandlerWidget({super.key});

  void _handleFileExport() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..multiple = true
      ..accept = '.csv,.json';

    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          print('Импортирован файл: ${file.name}');
        }
      }
    });
  }

  void _handleFileImport() {
    // JSON файл
    final jsonData = {
      'timestamp': DateTime.now().toIso8601String(),
      'data': [
        {'id': 1, 'value': 'test1'},
        {'id': 2, 'value': 'test2'},
      ]
    };

    // CSV файл
    final csvData = 'id,value\n1,test1\n2,test2';

    // Создаем и скачиваем JSON файл
    final jsonBlob = html.Blob(
      [jsonEncode(jsonData)],
      'application/json',
    );
    final jsonUrl = html.Url.createObjectUrlFromBlob(jsonBlob);
    html.AnchorElement(href: jsonUrl)
      ..setAttribute('download', 'export_${DateTime.now().millisecondsSinceEpoch}.json')
      ..click();
    html.Url.revokeObjectUrl(jsonUrl);

    // Создаем и скачиваем CSV файл
    final csvBlob = html.Blob(
      [csvData],
      'text/csv',
    );
    final csvUrl = html.Url.createObjectUrlFromBlob(csvBlob);
    html.AnchorElement(href: csvUrl)
      ..setAttribute('download', 'export_${DateTime.now().millisecondsSinceEpoch}.csv')
      ..click();
    html.Url.revokeObjectUrl(csvUrl);
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
            onPressed: _handleFileImport,
            icon: const Icon(Icons.download),
            label: const Text('Импорт данных'),
          ),
          ElevatedButton.icon(
            onPressed: _handleFileExport,
            icon: const Icon(Icons.upload),
            label: const Text('Экспорт данных'),
          ),
        ],
      ),
    );
  }
}