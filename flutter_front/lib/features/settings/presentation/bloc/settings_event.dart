part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class ExportSettingsEvent extends SettingsEvent {}

class ImportSettingsEvent extends SettingsEvent {}

class ExportFilesEvent extends SettingsEvent {
  final List<html.File> files;
  ExportFilesEvent(this.files);
}

class ImportFilesEvent extends SettingsEvent {}