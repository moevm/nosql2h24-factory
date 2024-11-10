import 'package:clean_architecture/shared/domain/usecases/get_theme_usecase.dart';
import 'package:clean_architecture/shared/domain/usecases/no_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/entry_usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final EntryUseCase entryUseCase;
  final GetThemeUseCase getThemeUseCase;

  SplashBloc({
    required this.checkAuthStatusUseCase,
    required this.entryUseCase,
    required this.getThemeUseCase,
  }) : super(SplashInitial()) {
    on<InitializeApp>(_onInitializeApp);
    on<SelectUser>(_onSelectUser);
  }

  Future<void> _onInitializeApp(
      InitializeApp event,
      Emitter<SplashState> emit,
      ) async {
    final usersResult = await checkAuthStatusUseCase(NoParams());
    await usersResult.fold(
          (failure) async => emit(SplashError(message: 'Failed to check auth status')),
          (users) async {
        if (users.length == 1) {
          await entryUseCase(users.first);
          final theme = await getThemeUseCase();
          emit(SplashCompleted(isLoggedIn: true, theme: theme));
        } else if (users.length > 1) {
          emit(SplashMultipleUsers(users: users));
        } else {
          emit(SplashCompleted(isLoggedIn: false));
        }
      },
    );
  }

  Future<void> _onSelectUser(
      SelectUser event,
      Emitter<SplashState> emit,
      ) async {
    await entryUseCase(event.user);
    final theme = await getThemeUseCase();
    emit(SplashCompleted(isLoggedIn: true, theme: theme));
  }
}