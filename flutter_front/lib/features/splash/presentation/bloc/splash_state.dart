part of 'splash_bloc.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashCompleted extends SplashState {
  final bool isLoggedIn;
  final ThemeMode? theme;

  SplashCompleted({required this.isLoggedIn, this.theme});
}

class SplashMultipleUsers extends SplashState {
  final List<String> users;

  SplashMultipleUsers({required this.users});
}

class SplashError extends SplashState {
  final String message;

  SplashError({required this.message});
}