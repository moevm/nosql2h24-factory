import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/theme_service.dart';
import 'hover_effect.dart';
import 'navigation_panel.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: _buildAppBar(context, isSmallScreen),
      body: _buildBody(isSmallScreen),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isSmallScreen) {
    return AppBar(
      title: Text(title),
      actions: [
        _buildThemeToggle(),
        if (isSmallScreen) _buildMenuButton(context),
      ],
    );
  }

  Widget _buildThemeToggle() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return HoverScaleEffect(
          child: IconButton(
            icon: Icon(
              state.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        );
      },
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return HoverScaleEffect(
      child: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _showNavigationPanel(context),
      ),
    );
  }

  void _showNavigationPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => NavigationPanel(isVertical: true),
    );
  }

  Widget _buildBody(bool isSmallScreen) {
    if (isSmallScreen) {
      return body;
    }

    return Column(
      children: [
        Expanded(child: body),
        NavigationPanel(isVertical: false),
      ],
    );
  }
}