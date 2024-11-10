part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class ExportSettingsEvent extends SettingsEvent {}

class ImportSettingsEvent extends SettingsEvent {}