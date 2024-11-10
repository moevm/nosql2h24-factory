import 'package:clean_architecture/shared/domain/usecases/get_theme_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());
    final result = await loginUseCase(
      LoginParams(username: event.username, password: event.password, rememberMe: event.rememberMe),
    );
    result.fold(
          (failure) => emit(LoginFailure(error: failure.toString())),
          (_) => emit(LoginSuccess()),
    );
  }
}