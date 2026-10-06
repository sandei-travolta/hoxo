import 'package:flutter/material.dart';

import '../../../data/models/clients.dart';
import '../utils/text_utils.dart';
import 'status_chip.dart';

class ClientTable extends StatelessWidget {
  const ClientTable({
    super.key, 
    required this.clients,
    required this.selected,
    required this.onSelect,
  });

  final List<Client> clients;
  final Client? selected;
  final ValueChanged<Client> onSelect;

  static Widget _line({
    required Widget name,
    required Widget status,
    Widget? mobile,
    Widget? email,
  }) {
    Widget cell(int flex, Widget child) => Expanded(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
        );

    return Row(
      children: [
        cell(4, name),
        cell(2, status),
        if (mobile != null) cell(3, mobile),
        if (email != null) cell(4, email),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, c) {
        // Secondary columns drop out as the table gets narrower.
        final showMobile = c.maxWidth >= 560;
        final showEmail = c.maxWidth >= 760;

        Widget head(String t) => Text(
              t,
              style: text.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            );

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _line(
                name: head('Name'),
                status: head('Status'),
                mobile: showMobile ? head('Mobile') : null,
                email: showEmail ? head('Email') : null,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 96),
                itemCount: clients.length,
                itemBuilder: (context, i) {
                  final cl = clients[i];
                  final isSel = identical(cl, selected);
                  final fg = isSel ? scheme.onSecondary : scheme.onSurface;
                  final muted =
                      isSel ? scheme.onSecondary : scheme.onSurfaceVariant;
                  final bg = isSel
                      ? scheme.secondary
                      : (i.isOdd
                          ? scheme.secondary.withValues(alpha: 0.06)
                          : Colors.transparent);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Material(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => onSelect(cl),
                        child: SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _line(
                              name: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isSel
                                        ? scheme.onSecondary
                                        : scheme.secondaryContainer,
                                    child: Text(
                                      initial(cl.name),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isSel
                                            ? scheme.secondary
                                            : scheme.onSecondaryContainer,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      cl.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: text.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: fg,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              status: isSel
                                  ? Text(cl.status,
                                      style: text.bodySmall?.copyWith(color: fg))
                                  : StatusChip(status: cl.status),
                              mobile: showMobile
                                  ? Text(
                                      cl.mobile??"No mobile",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: text.bodySmall
                                          ?.copyWith(color: muted),
                                    )
                                  : null,
                              email: showEmail
                                  ? Text(
                                      cl.email??"No email",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: text.bodySmall
                                          ?.copyWith(color: muted),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
