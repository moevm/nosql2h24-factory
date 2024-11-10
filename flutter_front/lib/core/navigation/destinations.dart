import 'package:clean_architecture/features/charts/presentation/pages/charts_page.dart';
import 'package:clean_architecture/features/settings/presentation/page/settings_page.dart';
import 'package:clean_architecture/features/splash/presentation/pages/splash_screen.dart';
import 'package:clean_architecture/features/statistics/presentation/pages/statistics_page.dart';
import 'package:clean_architecture/features/warnings/presentation/pages/warnings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/login/presentation/pages/login_page.dart';

class NavigationRoute {
  final String label;
  final IconData icon;
  final String path;
  final Widget page;

  const NavigationRoute({
    required this.label,
    required this.icon,
    required this.path,
    required this.page,
  });
}

class AppRoutes {
  static const entry = NavigationRoute(
      label: 'Вход', icon: Icons.login, path: '/', page: SplashScreen());

  static const login = NavigationRoute(
      label: 'Логин', icon: Icons.login, path: '/login', page: LoginPage());

  static const home = NavigationRoute(
      label: 'Главная страница',
      icon: Icons.home,
      path: '/home',
      page: HomePage());

  static const warnings = NavigationRoute(
      label: 'Предупреждения',
      icon: Icons.warning_amber_sharp,
      path: '/warnings',
      page: WarningsPage());

  static const settings = NavigationRoute(
      label: 'Настройки',
      icon: Icons.settings,
      path: '/settings',
      page: SettingsPage());

  static const statistics = NavigationRoute(
      label: 'Статистика',
      icon: Icons.bar_chart,
      path: '/statistics',
      page: StatisticsPage());

  static const charts = NavigationRoute(
      label: 'Графики',
      icon: Icons.ssid_chart,
      path: '/charts',
      page: ChartsPage());

  List<NavigationRoute> panelRoutes = [
    entry,
    statistics,
    charts,
    home,
    warnings,
    settings,
  ];

  List<NavigationRoute> allRoutes = [
    entry,
    login,
    home,
    warnings,
    settings,
    statistics,
    charts,
  ];

  get goRouterList =>
      allRoutes
          .map((e) =>
          GoRoute(
            path: e.path,
            builder: (BuildContext context, GoRouterState state) {
              return e.page;
            },
          ))
          .toList();

  get navigationBarList =>
      panelRoutes.map(
              (e) => BottomNavigationBarItem(icon: Icon(e.icon), label: e.label)
      ).toList();

  NavigationRoute? getRouteByPath(String path) {
    return panelRoutes.firstWhere(
          (route) => route.path == path,
      orElse: () => throw Exception('Route not found: $path'),
    );
  }
}
