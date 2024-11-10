import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showLogoutDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => const LogoutDialog(),
  );
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Выход из аккаунта'),
      content: Text('Вы хотите выйти или войти в другой аккаунт?'),
      actions: <Widget>[
        TextButton(
          child: Text('Отмена'),
          onPressed: () => Navigator.of(context).pop('cancel'),
        ),
        TextButton(
          child: Text('Выйти'),
          onPressed: () => Navigator.of(context).pop('logout'),
        ),
        TextButton(
          child: Text('Войти в другой аккаунт'),
          onPressed: () => Navigator.of(context).pop('switch'),
        ),
        TextButton(
          child: Text('Войти в новый аккаунт'),
          onPressed: () => Navigator.of(context).pop('new'),
        ),
      ],
    );
  }
}