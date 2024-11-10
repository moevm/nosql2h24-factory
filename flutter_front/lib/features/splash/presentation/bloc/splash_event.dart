part of 'splash_bloc.dart';

abstract class SplashEvent {}

class InitializeApp extends SplashEvent {}

class SelectUser extends SplashEvent {
  final String user;

  SelectUser(this.user);
}