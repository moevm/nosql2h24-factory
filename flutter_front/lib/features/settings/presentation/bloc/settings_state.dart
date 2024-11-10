part of 'settings_bloc.dart';

abstract class SettingsState {
  final BottomMessage? message;
  const SettingsState({this.message});
}

class SettingsProcessing extends SettingsState{}

class SettingsLoaded extends SettingsState {
  final ThemeMode? theme;
  SettingsLoaded({super.message, this.theme});
}

class SettingsError extends SettingsState {
  final String errorMessage;

  SettingsError(this.errorMessage) : super(message: BottomMessage(errorMessage, isError: true));
}