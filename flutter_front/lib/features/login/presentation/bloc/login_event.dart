part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;
  final bool rememberMe;

  LoginSubmitted({required this.username, required this.password, required this.rememberMe});
}