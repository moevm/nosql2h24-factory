import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_service.dart';
import '../../../../locator_service.dart';
import '../bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashBloc>()..add(InitializeApp()),
      child: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            if(state.theme != null){
              context.read<ThemeCubit>().toggleTheme(theme: state.theme);
            }
            if (state.isLoggedIn) {
              context.go('/home');
            } else {
              context.go('/login');
            }
          }
        },
        builder: (context, state) {
          if (state is SplashMultipleUsers) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final selectedUser = await _showUserSelectionDialog(context, state.users);
              if (selectedUser != null) {
                context.read<SplashBloc>().add(SelectUser(selectedUser));
              }
            });
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Image.asset('assets/555.png'),
                  const SizedBox(height: 20),
                  if (state is! SplashMultipleUsers)
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String?> _showUserSelectionDialog(BuildContext context, List<String> users) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Выберите пользователя'),
          content: SingleChildScrollView(
            child: ListBody(
              children: users.map((user) => ListTile(
                title: Text(user),
                onTap: () => Navigator.of(dialogContext).pop(user),
              )).toList(),
            ),
          ),
        );
      },
    );
  }
}