import 'package:flutter/material.dart';
import 'package:hoxo/data/models/clients.dart';

import '../utils/text_utils.dart';
import 'contact_row.dart';
import 'section_tiltle.dart';
import 'status_chip.dart';

class ClientDetail extends StatelessWidget {
  const ClientDetail({super.key, required this.client, this.onClose});

  final Client client;

  /// When provided, a close button is shown (used by the side panel).
  final VoidCallback? onClose;
  bool _has(String? v) => v != null && v.trim().isNotEmpty;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final contacts = <ContactRow>[
      ContactRow(
          icon: Icons.phone_outlined, label: 'Mobile', value: client.mobile??"no contact"),
      ContactRow(
          icon: Icons.mail_outline_rounded, label: 'Email', value: client.email??"no email yet"),
      if (_has(client.website))
        ContactRow(
            icon: Icons.language_rounded,
            label: 'Website',
            value: client.website!),
      if (_has(client.twitter))
        ContactRow(
            icon: Icons.alternate_email_rounded,
            label: 'Twitter',
            value: client.twitter!),
      if (_has(client.instagram))
        ContactRow(
            icon: Icons.camera_alt_outlined,
            label: 'Instagram',
            value: client.instagram!),
      if (_has(client.facebook))
        ContactRow(
            icon: Icons.facebook_rounded,
            label: 'Facebook',
            value: client.facebook!),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onClose != null)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Close',
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
              ),
            )
          else
            const SizedBox(height: 16),
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: scheme.secondaryContainer,
              child: Text(
                initial(client.name),
                style: text.headlineSmall?.copyWith(
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Text(
              client.name,
              textAlign: TextAlign.center,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Center(child: StatusChip(status: client.status)),
          const SizedBox(height: 24),

          const SectionTitle('About'),
          Text(client.description, style: text.bodyMedium),
          const SizedBox(height: 24),

          const SectionTitle('Contact'),
          ...contacts,
          const SizedBox(height: 24),

          const SectionTitle('Notes'),
          if (client.notes.isEmpty)
            Text('No notes yet.',
                style:
                    text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant))
          else
            for (final note in client.notes)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: Icon(Icons.notes_rounded,
                    size: 20, color: scheme.onSurfaceVariant),
                title: Text(note),
              ),
        ],
      ),
    );
  }
}