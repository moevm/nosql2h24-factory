import 'package:clean_architecture/shared/domain/usecases/toggle_theme_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'app_theme.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final BaseTheme currentTheme;

  const ThemeState({required this.themeMode, required this.currentTheme});

  @override
  List<Object> get props => [themeMode, currentTheme];
}

class ThemeCubit extends Cubit<ThemeState> {
  final ToggleThemeUseCase toggleThemeUseCase;
  final LightTheme lightTheme;
  final DarkTheme darkTheme;

  ThemeCubit({required this.lightTheme, required this.darkTheme, required this.toggleThemeUseCase})
      : super(ThemeState(themeMode: ThemeMode.light, currentTheme: lightTheme));

  void toggleTheme({ThemeMode? theme, bool needToSave=true}) {
    final newThemeMode = theme ?? (state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    if(needToSave) toggleThemeUseCase(newThemeMode);
    final newTheme = newThemeMode == ThemeMode.light ? lightTheme : darkTheme;
    emit(ThemeState(themeMode: newThemeMode, currentTheme: newTheme));
  }
}