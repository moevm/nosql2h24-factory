import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/domain/usecases/no_params.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/export_settings_usecase.dart';
import '../../domain/usecases/import_settings_usecase.dart';
import '../widgets/settings_message.dart';

part 'settings_event.dart';

part 'settings_state.dart';

// settings_bloc.dart
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ExportSettingsUseCase exportSettings;
  final ImportSettingsUseCase importSettings;

  SettingsBloc({
    required this.exportSettings,
    required this.importSettings,
  }) : super(SettingsLoaded()) {
    on<ExportSettingsEvent>(_onExportSettings);
    on<ImportSettingsEvent>(_onImportSettings);
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
}
