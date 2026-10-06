import 'package:flutter/material.dart';
import 'package:hoxo/data/models/clients.dart';
import 'package:hoxo/ui/clients/widgets/cient_details.dart';
import 'widgets/add_client_form.dart';
import 'widgets/client_table.dart';
import 'widgets/client_tile.dart';
import 'widgets/tab_item.dart';

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
        child: ClientTable(
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
        itemBuilder: (context, i) => ClientTile(
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
                      TabItem(
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








