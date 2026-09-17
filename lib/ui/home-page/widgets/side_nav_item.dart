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
    //check if is currwent path
    final isActive = currentPath == widget.path;

    final Color backgroundColor;
    final Color foregroundColor;
    if (isActive) {
      backgroundColor = _isHovering
          ? Color(0xFF2CBA7A).withOpacity(0.8)
          : Color(0xFF2CBA7A);
      foregroundColor = colorScheme.onPrimary;
    } else if (_isHovering) {
      backgroundColor = _isHovering
          ? Color(0xFFF6F6F6)
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
          onTap: () => context.go(widget.path),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..scale((_isHovering && !isActive) ? 1.03 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              
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