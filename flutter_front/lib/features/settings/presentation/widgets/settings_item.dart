import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}