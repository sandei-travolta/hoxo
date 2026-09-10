import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hoxo/routing/routes.dart';
import 'package:hoxo/ui/home-page/home_page.dart';
import 'package:hoxo/ui/landing-page/landing_page.dart';

final GoRouter goRouter=GoRouter(
  initialLocation: Routes.landingPage,
  routes: [
    GoRoute(
      path: Routes.landingPage,
      builder: (context,state)=>LandingPage()
      ),
    GoRoute(
      path: Routes.homePage,
      pageBuilder: (context,state){
        return CustomTransitionPage(
          child: const HomePage(), 
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
      }
      )  
  ]
);