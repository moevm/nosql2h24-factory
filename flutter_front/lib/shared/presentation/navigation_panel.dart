import 'package:clean_architecture/features/login/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/features/splash/domain/usecases/logout_usecase.dart';
import 'package:clean_architecture/locator_service.dart';
import 'package:clean_architecture/shared/domain/usecases/no_params.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../core/navigation/destinations.dart';
import '../../features/splash/presentation/widgets/logout_dialog.dart';
import 'hover_effect.dart';

class NavigationPanel extends StatelessWidget {
  final bool isVertical;
  NavigationPanel({super.key, required this.isVertical});

  @override
  Widget build(BuildContext context) {
    final appRoutes = GetIt.I<AppRoutes>();
    final router = GetIt.I<GoRouter>();
    final logoutUseCase = GetIt.I<LogoutUseCase>();

    final curPath = router.routerDelegate.currentConfiguration.fullPath;

    return isVertical
        ? verticalNavigationPanel(context, appRoutes, curPath, router, logoutUseCase)
        : horizontalNavigationPanel(context, appRoutes, curPath, router, logoutUseCase);
  }

  Widget buildNavigationItem(
      BuildContext context, NavigationRoute route, curPath, router, LogoutUseCase logoutUseCase) {
    final isSelected = route.path == curPath;
    return ListTile(
      leading: Icon(route.icon,
          color: isSelected ? Theme.of(context).primaryColor : null),
      title: Text(route.label),
      selected: isSelected,
      onTap: () => _onTap(logoutUseCase, route, router, context),
    );
  }

  Widget verticalNavigationPanel(BuildContext context, AppRoutes appRoutes, curPath, router, LogoutUseCase logoutUseCase) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ListView(
        shrinkWrap: true,
        children: appRoutes.panelRoutes.map<Widget>((route) => buildNavigationItem(context, route, curPath, router, logoutUseCase)).toList(),
      ),
    );
  }

  Widget horizontalNavigationPanel(
      BuildContext context, appRoutes, curPath, router, LogoutUseCase logoutUseCase) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Wrap(
          spacing: 30,
          children: appRoutes.panelRoutes.map<Widget>((NavigationRoute route) {
            final isSelected = route.path == curPath;
            return HoverScaleEffect(
              child: IconButton(
                icon: Icon(route.icon),
                color: isSelected ? Theme.of(context).primaryColor : null,
                onPressed: () => _onTap(logoutUseCase, route, router, context),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _onTap(LogoutUseCase logout, NavigationRoute route, GoRouter router, BuildContext context) async {
    if (route.path == "/") {
      final choice = await showLogoutDialog(context);

      switch (choice) {
        case 'logout':
          await logout(NoParams());
          router.go('/');
          return;
        case 'switch':
          router.go('/');
          return;
        case 'new':
          router.go('/login');
          return;
        case 'cancel':
        default:
          return;
      }
    }

    router.go(route.path);
  }
}