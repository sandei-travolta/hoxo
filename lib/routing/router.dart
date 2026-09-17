import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hoxo/routing/routes.dart';
import 'package:hoxo/ui/clients/clients_page.dart';
import 'package:hoxo/ui/dashboard/dashboard_page.dart';
import 'package:hoxo/ui/home-page/home_page.dart';
import 'package:hoxo/ui/landing-page/landing_page.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: Routes.landingPage,
  routes: [
    GoRoute(
      path: Routes.landingPage,
      builder: (context, state) => LandingPage(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return HomePage(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.dashboard,
          pageBuilder: (context, state) {
            return _buildPage(
              key: state.pageKey,
              child: DashboardPage(),
            );
          },
        ),

        GoRoute(
          path: Routes.clients,
          pageBuilder: (context, state) {
            return _buildPage(
              key: state.pageKey,
              child: ClientsPage(),
            );
          },
        ),
      ],
    ),
  ],
);

CustomTransitionPage _buildPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,

    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),

    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.05, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}