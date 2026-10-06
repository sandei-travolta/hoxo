import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/snack_bar.dart';


class ContactRow extends StatelessWidget {
  const ContactRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _copy(context, label, value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: scheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  Text(
                    value,
                    style: text.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Icon(Icons.copy_rounded, size: 16, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
  
  Future<void> _copy(BuildContext context, String label, String value) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) return;
  AppSnackBar.message(context, "Copied to clipboard");
}

}