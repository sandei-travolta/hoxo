import 'package:flutter/material.dart';
import 'package:hoxo/routing/routes.dart';
import 'package:hoxo/ui/themes/colors.dart';

import 'side_nav_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 1),
              )
            ],
            borderRadius: .only(topRight: .circular(12.0),bottomRight: .circular(12.0))
      ),
      width: 230.0,
      child: Column(
        children: [
          Text("hoxo",style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 50.0),
          SideNavItem(path: Routes.dashboard, label: 'DashBoard',icon: Icons.home_outlined),
          const SizedBox(height: 15),
          SideNavItem(path: Routes.clients, label: 'Clients',icon: Icons.people),
        ],
      ),
    );
  }
}

