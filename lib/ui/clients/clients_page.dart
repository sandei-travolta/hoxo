import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoxo/data/models/clients.dart';

import 'widgets/add_client_form.dart';

/// Dummy data.
final List<Client> dummyClients = [
  Client(
    name: 'Wanjiru Bakery',
    mobile: '+254 712 345 678',
    email: 'orders@wanjirubakery.co.ke',
    twitter: '@wanjirubakes',
    instagram: '@wanjiru.bakery',
    facebook: 'Wanjiru Bakery Kisumu',
    website: 'wanjirubakery.co.ke',
    description:
        'Family-run bakery with three outlets. Wants online ordering and a loyalty card for regular customers.',
    notes: [
      'Prefers calls in the morning',
      'Pays in two instalments',
      'Send menu photos before kickoff',
    ],
    status: 'Active',
  ),
  Client(
    name: 'Lakeview Clinic',
    mobile: '+254 733 210 984',
    email: 'admin@lakeviewclinic.org',
    twitter: null,
    instagram: null,
    facebook: 'Lakeview Clinic',
    website: 'lakeviewclinic.org',
    description:
        'Outpatient clinic needing an appointment booking app with SMS reminders for patients.',
    notes: ['Decision maker is the clinic manager', 'Needs a data privacy review'],
    status: 'Active',
  ),
  Client(
    name: 'Brian Kamau',
    mobile: '+254 701 998 223',
    email: 'brian.kamau@gmail.com',
    twitter: '@briankamau',
    instagram: null,
    facebook: null,
    website: null,
    description:
        'Freelance photographer looking for a portfolio site with a client proofing gallery.',
    notes: ['Budget still unconfirmed'],
    status: 'Lead',
  ),
  Client(
    name: 'Otieno & Sons Logistics',
    mobile: '+254 722 456 019',
    email: 'info@otienologistics.com',
    twitter: null,
    instagram: null,
    facebook: null,
    website: 'otienologistics.com',
    description:
        'Small freight company that wants a dashboard to track deliveries and drivers.',
    notes: [
      'Quoted in August, awaiting reply',
      'Follow up next Monday',
    ],
    status: 'Lead',
  ),
  Client(
    name: 'Nuru Fashion House',
    mobile: '+254 745 667 310',
    email: 'hello@nurufashion.shop',
    twitter: null,
    instagram: '@nuru.fashionhouse',
    facebook: null,
    website: null,
    description:
        'Boutique brand that used our team for an online store last year. Project completed.',
    notes: [],
    status: 'Inactive',
  ),
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _initial(String name) =>
    name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

bool _has(String? v) => v != null && v.trim().isNotEmpty;

Future<void> _copy(BuildContext context, String label, String value) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        duration: const Duration(seconds: 2),
      ),
    );
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  static const double _wideBreakpoint = 900;
  static const List<String> _filters = ['All', 'Active', 'Lead', 'Inactive'];

  // Swap this for your real data source later.
  final List<Client> _clients = List.of(dummyClients);
  final TextEditingController _search = TextEditingController();

  String _filter = 'All';
  Client? _selected;
  bool _panelOpen = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Client> get _visible {
    final q = _search.text.trim().toLowerCase();
    return _clients.where((c) {
      final statusOk =
          _filter == 'All' || c.status.toLowerCase() == _filter.toLowerCase();
      final queryOk = q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.email!.toLowerCase().contains(q) ||
          c.mobile!.contains(q) ||
          c.description.toLowerCase().contains(q);
      return statusOk && queryOk;
    }).toList();
  }

  /// Tapping the selected row again closes the panel.
  void _toggle(Client c) {
    setState(() {
      if (_panelOpen && identical(_selected, c)) {
        _panelOpen = false;
      } else {
        _selected = c;
        _panelOpen = true;
      }
    });
  }

  void _openDetail(Client client) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(client.name)),
          body: ClientDetail(client: client),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await addClientForm(context);
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        tooltip: "Add Client",
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= _wideBreakpoint;
          final panelWidth = (c.maxWidth * 0.3).clamp(340.0, 440.0).toDouble();
          final panelVisible = wide && _panelOpen && _selected != null;

          return Row(
            children: [
              Expanded(child: _buildMain(wide)),
              if (panelVisible) const VerticalDivider(width: 1),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: panelVisible ? panelWidth : 0,
                color: Theme.of(context).colorScheme.surface,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    minWidth: panelWidth,
                    maxWidth: panelWidth,
                    child: _selected == null
                        ? const SizedBox.shrink()
                        : ClientDetail(
                            key: ValueKey(_selected),
                            client: _selected!,
                            onClose: () => setState(() => _panelOpen = false),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMain(bool wide) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final visible = _visible;
    final gutter = wide ? 24.0 : 16.0;

    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: color),
        );

    final title = Text(
      'Clients',
      style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
    );

    final search = SizedBox(
      width: wide ? 300 : double.infinity,
      child: TextField(
        controller: _search,
        cursorColor: scheme.onSurface,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search clients...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: border(scheme.outlineVariant),
          enabledBorder: border(scheme.outlineVariant),
          focusedBorder: border(scheme.secondary),
        ),
      ),
    );

    Widget body;
    if (visible.isEmpty) {
      body = const Center(child: Text('No clients match your search.'));
    } else if (wide) {
      body = Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter),
        child: _ClientTable(
          clients: visible,
          selected: _panelOpen ? _selected : null,
          onSelect: _toggle,
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => _ClientTile(
          client: visible[i],
          onTap: () => _openDetail(visible[i]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: wide
              ? Row(children: [title, const Spacer(), search])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [title, const SizedBox(height: 12), search],
                ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final f in _filters)
                      _TabItem(
                        label: f,
                        selected: f == _filter,
                        onTap: () => setState(() => _filter = f),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: selected ? scheme.secondary : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Table (wide screens)
// ---------------------------------------------------------------------------

class _ClientTable extends StatelessWidget {
  const _ClientTable({
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
                                      _initial(cl.name),
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
                                  : _StatusChip(status: cl.status),
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

// ---------------------------------------------------------------------------
// Card (narrow screens)
// ---------------------------------------------------------------------------

class _ClientTile extends StatelessWidget {
  const _ClientTile({required this.client, required this.onTap});

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
                  _initial(client.name),
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
                        _StatusChip(status: client.status),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

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

// ---------------------------------------------------------------------------
// Detail (side panel on wide screens, full page on narrow)
// ---------------------------------------------------------------------------

class ClientDetail extends StatelessWidget {
  const ClientDetail({super.key, required this.client, this.onClose});

  final Client client;

  /// When provided, a close button is shown (used by the side panel).
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final contacts = <_ContactRow>[
      _ContactRow(
          icon: Icons.phone_outlined, label: 'Mobile', value: client.mobile??"no contact"),
      _ContactRow(
          icon: Icons.mail_outline_rounded, label: 'Email', value: client.email??"no email yet"),
      if (_has(client.website))
        _ContactRow(
            icon: Icons.language_rounded,
            label: 'Website',
            value: client.website!),
      if (_has(client.twitter))
        _ContactRow(
            icon: Icons.alternate_email_rounded,
            label: 'Twitter',
            value: client.twitter!),
      if (_has(client.instagram))
        _ContactRow(
            icon: Icons.camera_alt_outlined,
            label: 'Instagram',
            value: client.instagram!),
      if (_has(client.facebook))
        _ContactRow(
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
                _initial(client.name),
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
          Center(child: _StatusChip(status: client.status)),
          const SizedBox(height: 24),

          const _SectionTitle('About'),
          Text(client.description, style: text.bodyMedium),
          const SizedBox(height: 24),

          const _SectionTitle('Contact'),
          ...contacts,
          const SizedBox(height: 24),

          const _SectionTitle('Notes'),
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

/// A contact line. Tap to copy the value.
class _ContactRow extends StatelessWidget {
  const _ContactRow({
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
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}