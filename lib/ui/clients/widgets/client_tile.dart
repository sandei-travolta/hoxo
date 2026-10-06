import 'package:flutter/material.dart';
import 'package:hoxo/data/models/clients.dart';
import 'package:hoxo/ui/clients/widgets/status_chip.dart';

import '../utils/text_utils.dart';

class ClientTile extends StatelessWidget {
  const ClientTile({
    super.key,
    required this.client, required this.onTap});

  final Client client;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: scheme.secondaryContainer,
                child: Text(
                  initial(client.name),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            client.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusChip(status: client.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client.mobile??"No mobile",
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    Text(
                      client.email??"No Email",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
