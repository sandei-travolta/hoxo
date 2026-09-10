import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hoxo/ui/themes/colors.dart';

class SideNavItem extends StatefulWidget {
  const SideNavItem({
    super.key,
    required this.path,
    required this.label,
    this.icon = Icons.home_outlined,
  });

  final String path;
  final String label;
  final IconData icon;

  @override
  State<SideNavItem> createState() => _SideNavItemState();
}

class _SideNavItemState extends State<SideNavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentPath = GoRouterState.of(context).uri.path;
    final isActive = currentPath == widget.path;

    final Color backgroundColor;
    final Color foregroundColor;
    if (isActive) {
      backgroundColor = _isHovering
          ? AppColors.blue3.withOpacity(0.6)
          : AppColors.blue3;
      foregroundColor = colorScheme.onPrimary;
    } else if (_isHovering) {
      backgroundColor = _isHovering
          ? AppColors.blue3
          : colorScheme.primary;
      foregroundColor = colorScheme.primary;
    } else {
      backgroundColor = Colors.white;
      foregroundColor = colorScheme.onSurfaceVariant;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () => context.go(widget.path),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..scale((_isHovering && !isActive) ? 1.03 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              boxShadow:  [
                      BoxShadow(
                        color: const Color.fromRGBO(60, 64, 67, 0.3),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: const Color.fromRGBO(60, 64, 67, 0.15),
                        blurRadius: 10,
                        spreadRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ]
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                ),
                const SizedBox(width: 15.0),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive? Colors.white:Colors.black,
                        fontWeight: FontWeight.w600 
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}