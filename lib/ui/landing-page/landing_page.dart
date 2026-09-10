import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> 
with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _animationController=AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900)
      );
      _slideAnimation=Tween<Offset>(
        begin: const Offset(0, 2.0),
        end: Offset.zero
      ).animate(
        CurvedAnimation(
          parent: _animationController, 
          curve: Curves.easeOut
          )
      );
      _fadeAnimation=Tween<double>(
        begin: 0,
        end: 1 
        ).animate(
          CurvedAnimation(
            parent: _animationController,
             curve: Curves.easeOut
             ));
      _animationController.forward().then((_){
        if(!mounted) return;
        context.go(Routes.dashboard);
      });
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text("hoxo",
            style: Theme.of(context).textTheme.headlineLarge,
            ),),
            ),
      ),
    );
  }
}