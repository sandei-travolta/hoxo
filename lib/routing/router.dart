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
      builder: (context,state)=>HomePage()
      )  
  ]
);