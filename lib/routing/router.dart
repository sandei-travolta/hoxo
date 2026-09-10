import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hoxo/routing/routes.dart';
import 'package:hoxo/ui/clients/clients_page.dart';
import 'package:hoxo/ui/dashboard/dashboard_page.dart';
import 'package:hoxo/ui/home-page/home_page.dart';
import 'package:hoxo/ui/landing-page/landing_page.dart';

final GoRouter goRouter=GoRouter(
  initialLocation: Routes.landingPage,
  routes: [
    GoRoute(
      path: Routes.landingPage,
      builder: (context,state)=>LandingPage()
      ),
    ShellRoute(
      pageBuilder: (context,state,child){
        return CustomTransitionPage(
          child: HomePage(child: child), 
          transitionsBuilder: (
            context,
            animation,
            secondarAnimation,
            child
            ){
              final slideAnimation=Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero
              ).animate(
                CurvedAnimation(
                  parent: animation, 
                  curve: Curves.easeOut)
                  );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: child)
                  );
            });
      },
      routes: [
        GoRoute(
          path: Routes.dashboard,
          builder: (context,state)=>DashboardPage()
          ),
        GoRoute(
          path: Routes.clients,
          builder: (context,state)=>ClientsPage()
          )  
      ]),
  ]
);