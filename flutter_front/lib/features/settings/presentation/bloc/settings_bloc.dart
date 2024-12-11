import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html' as html;
import '../../../../shared/domain/usecases/no_params.dart';
import '../../data/datasorces/settings_remote_data_source.dart';
import '../../domain/usecases/export_settings_usecase.dart';
import '../../domain/usecases/import_settings_usecase.dart';
import '../widgets/settings_message.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ExportSettingsUseCase exportSettings;
  final ImportSettingsUseCase importSettings;
  final SettingsRemoteDataSource remoteDataSource;

  SettingsBloc({
    required this.exportSettings,
    required this.importSettings,
    required this.remoteDataSource,
  }) : super(SettingsLoaded()) {
    on<ExportSettingsEvent>(_onExportSettings);
    on<ImportSettingsEvent>(_onImportSettings);
    on<ExportFilesEvent>(_onExportFiles);
    on<ImportFilesEvent>(_onImportFiles);
  }

  Future<void> _onExportSettings(
      ExportSettingsEvent event,
      Emitter<SettingsState> emit,
      ) async {
    emit(SettingsProcessing());
    final settingsRes = await exportSettings(NoParams());
    settingsRes.fold(
          (f) => emit(SettingsLoaded(
        message: BottomMessage("Не удалось экспортировать настройки",
            isError: true),
      )),
          (settings) => emit(SettingsLoaded(
        message: BottomMessage("Настройки успешно сохранены на сервере"),
      )),
    );
  }

  Future<void> _onImportSettings(
      ImportSettingsEvent event,
      Emitter<SettingsState> emit,
      ) async {
    emit(SettingsProcessing());
    final settingsRes = await importSettings(NoParams());
    settingsRes.fold(
          (f) => emit(SettingsLoaded(
        message: BottomMessage("Не удалось импортировать настройки",
            isError: true),
      )),
          (theme) => emit(SettingsLoaded(
          message:
          BottomMessage("Настройки успешно импортированы и применены"),
          theme: theme)),
    );
  }

  Future<void> _onExportFiles(
      ExportFilesEvent event,
      Emitter<SettingsState> emit,
      ) async {
    try {
      if (event.files.length != 2) {
        emit(SettingsLoaded(
            message: BottomMessage(
                "Необходимо выбрать два файла",
                isError: true
            )
        ));
        return;
      }

      // Находим файлы mongo и influx по имени
      var mongoFile = event.files.firstWhere(
            (file) => file.name.toLowerCase().contains('mongo'),
        orElse: () => throw Exception("Файл mongo не найден"),
      );

      var influxFile = event.files.firstWhere(
            (file) => file.name.toLowerCase().contains('influx'),
        orElse: () => throw Exception("Файл influx не найден"),
      );

      if (!mongoFile.name.endsWith('.txt') || !influxFile.name.endsWith('.txt')) {
        emit(SettingsLoaded(
            message: BottomMessage(
                "Оба файла должны быть формата .txt",
                isError: true
            )
        ));
        return;
      }

      emit(SettingsLoaded(
          message: BottomMessage(
            "Файлы обрабатываются. Ожидайте ответ",
          )
      ));

      // Чтение содержимого файлов
      final mongoContent = await _readFileContent(mongoFile);
      final influxContent = await _readFileContent(influxFile);

      emit(SettingsLoaded(
          message: BottomMessage(
            "Файлы отправлены. Ожидайте ответ",
          )
      ));

      // Отправка содержимого на сервер
      await remoteDataSource.exportData(mongoContent, influxContent);

      emit(SettingsLoaded(
          message: BottomMessage(
              "Данные успешно обновлены",
              isError: false
          )
      ));
    } catch (e) {
      emit(SettingsLoaded(
          message: BottomMessage(
              "Ошибка при загрузке файлов: $e",
              isError: true
          )
      ));
    }
  }

  Future<String> _readFileContent(html.File file) async {
    final reader = html.FileReader();
    reader.readAsText(file);

    final completer = Completer<String>();
    reader.onLoad.listen((e) {
      completer.complete(reader.result as String);
    });

    return await completer.future;
  }

  Future<void> _onImportFiles(
      ImportFilesEvent event,
      Emitter<SettingsState> emit,
      ) async {
    try {
      emit(SettingsLoaded(
          message: BottomMessage(
            "Запрос на получение отправлен. Ожидайте получения",
          )
      ));

      final snapshot = await remoteDataSource.importData();

      // Создаем и скачиваем Mongo файл
      _downloadFile(snapshot.mongo, 'mongo_${DateTime.now().millisecondsSinceEpoch}.txt');

      // Создаем и скачиваем Influx файл
      _downloadFile(snapshot.influx, 'influx_${DateTime.now().millisecondsSinceEpoch}.txt');

      emit(SettingsLoaded(
          message: BottomMessage("Файлы успешно скачаны", isError: false)
      ));
    } catch (e) {
      emit(SettingsLoaded(
          message: BottomMessage("Ошибка при скачивании файлов: $e", isError: true)
      ));
    }
  }

  void _downloadFile(String content, String filename) {
    final blob = html.Blob([content], 'text/plain');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}