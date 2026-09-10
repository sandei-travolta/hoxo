import 'package:flutter/material.dart';
import 'package:hoxo/ui/home-page/widgets/sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key,required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Sidebar(),
        Expanded(child: child)
      ],
    );
  }
}