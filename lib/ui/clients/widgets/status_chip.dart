import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status
    });

  final String status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Color bg;
    final Color fg;
    switch (status.toLowerCase()) {
      case 'active':
        bg = scheme.secondaryContainer;
        fg = scheme.onSecondaryContainer;
      case 'lead':
        bg = scheme.tertiaryContainer;
        fg = scheme.onTertiaryContainer;
      default:
        bg = scheme.surfaceContainerHighest;
        fg = scheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
