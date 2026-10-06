import 'package:flutter/material.dart';
import 'package:hoxo/data/models/milestone.dart';
import 'package:hoxo/data/models/project.dart';
import 'package:hoxo/ui/projects/widgets/create_project_form.dart';

/// Dummy data. Dates are relative to now so the progress bars look realistic.
final DateTime _now = DateTime.now();

final List<Project> dummyProjects = [
  Project(
    title: 'Portfolio Website',
    description:
        'Redesign my personal portfolio with case studies, a blog section and a contact form that sends email.',
    type: 'Personal',
    notes: [
      'Pick a typeface pairing',
      'Write three case studies',
      'Compress hero images',
    ],
    milestone: Milestone(
      start: _now.subtract(const Duration(days: 12)),
      end: _now.add(const Duration(days: 9)),
      title: 'Design approved',
      description: 'Finish the home and case study layouts and get sign-off.',
    ),
  ),
  Project(
    title: 'Clinic Booking App',
    description:
        'Mobile app for a local clinic. Patients book appointments, receive reminders and view visit history.',
    type: 'Paid',
    notes: [
      'Client wants M-Pesa payments',
      'Confirm SMS provider pricing',
      'Send the invoice for phase 1',
    ],
    milestone: Milestone(
      start: _now.subtract(const Duration(days: 30)),
      end: _now.add(const Duration(days: 4)),
      title: 'Beta release',
      description: 'Booking flow, reminders and admin dashboard ready for testers.',
    ),
  ),
  Project(
    title: 'Budget Tracker',
    description:
        'Small offline-first app to log daily spending and see monthly summaries by category.',
    type: 'Personal',
    notes: ['Decide between Isar and Drift'],
    milestone: Milestone(
      start: _now.add(const Duration(days: 3)),
      end: _now.add(const Duration(days: 24)),
      title: 'Data layer',
      description: 'Local database, models and repository tests.',
    ),
  ),
  Project(
    title: 'School Fees Portal',
    description:
        'Web portal for a school to publish fee statements and let parents track payments per term.',
    type: 'Paid',
    notes: [
      'Import existing student records',
      'Parent login via phone number',
      'Printable receipts',
      'Deploy to staging for review',
    ],
    milestone: Milestone(
      start: _now.subtract(const Duration(days: 45)),
      end: _now.subtract(const Duration(days: 3)),
      title: 'Payments integration',
      description: 'Connect the payment gateway and reconcile transactions.',
    ),
  ),
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}

double _progress(Milestone m) {
  final total = m.end.difference(m.start).inSeconds;
  if (total <= 0) return 1.0;
  final done = DateTime.now().difference(m.start).inSeconds;
  return (done / total).clamp(0.0, 1.0).toDouble();
}

String _timeLeft(Milestone m) {
  final now = DateTime.now();
  if (now.isBefore(m.start)) {
    final days = m.start.difference(now).inDays + 1;
    return 'Starts in $days ${days == 1 ? 'day' : 'days'}';
  }
  final days = m.end.difference(now).inDays;
  if (now.isAfter(m.end)) {
    final late = now.difference(m.end).inDays;
    return 'Overdue by $late ${late == 1 ? 'day' : 'days'}';
  }
  if (days == 0) return 'Due today';
  return '$days ${days == 1 ? 'day' : 'days'} left';
}

bool _isOverdue(Milestone m) => DateTime.now().isAfter(m.end);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  static const double _wideBreakpoint = 900;
  static const List<String> _filters = ['All', 'Personal', 'Paid'];

  // Swap this for your real data source later.
  final List<Project> _projects = List.of(dummyProjects);
  final TextEditingController _search = TextEditingController();

  String _filter = 'All';
  Project? _selected;
  bool _panelOpen = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Project> get _visible {
    final q = _search.text.trim().toLowerCase();
    return _projects.where((p) {
      final typeOk =
          _filter == 'All' || p.type.toLowerCase() == _filter.toLowerCase();
      final queryOk = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
      return typeOk && queryOk;
    }).toList();
  }

  /// Tapping the selected row again closes the panel.
  void _toggle(Project p) {
    setState(() {
      if (_panelOpen && identical(_selected, p)) {
        _panelOpen = false;
      } else {
        _selected = p;
        _panelOpen = true;
      }
    });
  }

  void _openDetail(Project project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(project.title)),
          body: ProjectDetail(project: project),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createProjectForm(context);
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        tooltip: "Add Project",
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
                        : ProjectDetail(
                            key: ValueKey(_selected),
                            project: _selected!,
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
      'Projects',
      style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
    );

    final search = SizedBox(
      width: wide ? 300 : double.infinity,
      child: TextField(
        controller: _search,
        cursorColor: scheme.onSurface,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search projects...',
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
      body = const Center(child: Text('No projects match your search.'));
    } else if (wide) {
      body = Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter),
        child: _ProjectTable(
          projects: visible,
          selected: _panelOpen ? _selected : null,
          onSelect: _toggle,
        ),
      );
    } else {
      body = _ProjectList(
        projects: visible,
        onSelect: (i) => _openDetail(visible[i]),
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
              Row(
                children: [
                  for (final f in _filters)
                    _TabItem(
                      label: f,
                      selected: f == _filter,
                      onTap: () => setState(() => _filter = f),
                    ),
                ],
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
// List
// ---------------------------------------------------------------------------

class _ProjectList extends StatelessWidget {
  const _ProjectList({
    required this.projects,
    required this.onSelect,
    this.selectedIndex,
  });

  final List<Project> projects;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => _ProjectTile(
        project: projects[i],
        selected: i == selectedIndex,
        onTap: () => onSelect(i),
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.project,
    required this.selected,
    required this.onTap,
  });

  final Project project;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final overdue = _isOverdue(project.milestone);

    return Material(
      color: selected ? scheme.secondaryContainer : scheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? scheme.secondary : scheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TypeChip(type: project.type),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress(project.milestone),
                  minHeight: 5,
                  color: overdue ? scheme.error : scheme.secondary,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.milestone.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall,
                    ),
                  ),
                  Text(
                    _timeLeft(project.milestone),
                    style: text.bodySmall?.copyWith(
                      color: overdue ? scheme.error : scheme.onSurfaceVariant,
                      fontWeight: overdue ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final paid = type.toLowerCase() == 'paid';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: paid ? scheme.tertiaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: paid
                  ? scheme.onTertiaryContainer
                  : scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Table (wide screens)
// ---------------------------------------------------------------------------
class _ProjectTable extends StatelessWidget {
  const _ProjectTable({
    required this.projects,
    required this.selected,
    required this.onSelect,
  });

  final List<Project> projects;
  final Project? selected;
  final ValueChanged<Project> onSelect;

  static Widget _line({
    required Widget title,
    required Widget type,
    required Widget milestone,
    Widget? progress,
    Widget? due,
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
        cell(4, title),
        cell(2, type),
        cell(3, milestone),
        if (progress != null) cell(3, progress),
        if (due != null) cell(2, due),
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
        final showProgress = c.maxWidth >= 560;
        final showDue = c.maxWidth >= 760;

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
                title: head('Title'),
                type: head('Type'),
                milestone: head('Milestone'),
                progress: showProgress ? head('Progress') : null,
                due: showDue ? head('Due') : null,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 96),
                itemCount: projects.length,
                itemBuilder: (context, i) {
                  final p = projects[i];
                  final isSel = identical(p, selected);
                  final overdue = _isOverdue(p.milestone);
                  final fg = isSel ? scheme.onSecondary : scheme.onSurface;
                  final muted =
                      isSel ? scheme.onSecondary : scheme.onSurfaceVariant;
                  final bg = isSel
                      ? scheme.secondary
                      : (i.isOdd
                          ? scheme.secondary.withValues(alpha: 0.06)
                          : Colors.transparent);
                  final pct = (_progress(p.milestone) * 100).round();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Material(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => onSelect(p),
                        child: SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _line(
                              title: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isSel
                                        ? scheme.onSecondary
                                        : scheme.secondaryContainer,
                                    child: Text(
                                      p.title.isEmpty
                                          ? '?'
                                          : p.title[0].toUpperCase(),
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
                                      p.title,
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
                              type: isSel
                                  ? Text(p.type,
                                      style: text.bodySmall?.copyWith(color: fg))
                                  : _TypeChip(type: p.type),
                              milestone: Text(
                                p.milestone.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.bodyMedium?.copyWith(color: fg),
                              ),
                              progress: showProgress
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: _progress(p.milestone),
                                              minHeight: 6,
                                              color: isSel
                                                  ? scheme.onSecondary
                                                  : (overdue
                                                      ? scheme.error
                                                      : scheme.secondary),
                                              backgroundColor: isSel
                                                  ? scheme.onSecondary
                                                      .withValues(alpha: 0.3)
                                                  : scheme
                                                      .surfaceContainerHighest,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 36,
                                          child: Text(
                                            '$pct%',
                                            textAlign: TextAlign.right,
                                            style: text.bodySmall
                                                ?.copyWith(color: muted),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                              due: showDue
                                  ? Text(
                                      _formatDate(p.milestone.end),
                                      style: text.bodySmall?.copyWith(
                                        color: overdue && !isSel
                                            ? scheme.error
                                            : muted,
                                      ),
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
// Detail (side panel on wide screens, full page on narrow)
// ---------------------------------------------------------------------------
class ProjectDetail extends StatelessWidget {
  const ProjectDetail({super.key, required this.project, this.onClose});

  final Project project;

  /// When provided, a close button is shown (used by the side panel).
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final m = project.milestone;
    final overdue = _isOverdue(m);
    final pct = (_progress(m) * 100).round();

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
                project.title.isEmpty ? '?' : project.title[0].toUpperCase(),
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
              project.title,
              textAlign: TextAlign.center,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Center(child: _TypeChip(type: project.type)),
          const SizedBox(height: 24),

          const _SectionTitle('About'),
          Text(project.description, style: text.bodyMedium),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _Info('Start date', _formatDate(m.start))),
              Expanded(child: _Info('Due date', _formatDate(m.end))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Info('Progress', '$pct%')),
              Expanded(
                child: _Info(
                  'Status',
                  _timeLeft(m),
                  color: overdue ? scheme.error : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Milestone'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style:
                      text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  m.description,
                  style: text.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _progress(m),
                    minHeight: 8,
                    color: overdue ? scheme.error : scheme.secondary,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Notes'),
          if (project.notes.isEmpty)
            Text('No notes yet.',
                style:
                    text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant))
          else
            for (final note in project.notes)
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

class _Info extends StatelessWidget {
  const _Info(this.label, this.value, {this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}