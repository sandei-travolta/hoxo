import 'package:flutter/material.dart';


import '../../../data/models/clients.dart';


/// Opens the "Add Client" dialog.
/// Returns the new [Client], or null if the dialog was cancelled.
Future<Client?> addClientForm(BuildContext context) {
  return showDialog<Client>(
    context: context,
    builder: (_) => const _AddClientDialog(),
  );
}

/// The nullable fields of [Client] that can be added on demand.
enum _Optional {
  mobile('Mobile', Icons.phone_outlined, '+254 7XX XXX XXX', TextInputType.phone),
  email('Email', Icons.mail_outline_rounded, 'name@example.com',
      TextInputType.emailAddress),
  website('Website', Icons.language_rounded, 'example.com', TextInputType.url),
  twitter('Twitter', Icons.alternate_email_rounded, '@handle',
      TextInputType.text),
  instagram('Instagram', Icons.camera_alt_outlined, '@handle',
      TextInputType.text),
  facebook('Facebook', Icons.facebook_rounded, 'Page or profile name',
      TextInputType.text);

  const _Optional(this.label, this.icon, this.hint, this.keyboard);

  final String label;
  final IconData icon;
  final String hint;
  final TextInputType keyboard;
}

class _AddClientDialog extends StatefulWidget {
  const _AddClientDialog();

  @override
  State<_AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<_AddClientDialog> {
  static const List<String> _statuses = ['Lead', 'Active', 'Inactive'];

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _optional = TextEditingController();

  String _status = 'Lead';

  /// Optional values the user has added (insertion order is kept).
  final Map<_Optional, String> _added = {};

  /// The optional field whose input is currently open.
  _Optional? _adding;
  String? _optionalError;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _optional.dispose();
    super.dispose();
  }

  void _startAdding(_Optional field) {
    setState(() {
      _adding = _adding == field ? null : field; // tap again to close
      _optional.clear();
      _optionalError = null;
    });
  }

  /// Validates and stores the open optional input. Returns false on error.
  bool _commitOptional() {
    final field = _adding;
    if (field == null) return true;

    final value = _optional.text.trim();
    String? error;
    if (value.isEmpty) {
      error = 'Enter a value';
    } else if (field == _Optional.email &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      error = 'Enter a valid email';
    }

    if (error != null) {
      setState(() => _optionalError = error);
      return false;
    }

    setState(() {
      _added[field] = value;
      _adding = null;
      _optionalError = null;
      _optional.clear();
    });
    return true;
  }

  void _save() {
    // Don't silently drop a value that was typed but not added yet.
    if (_adding != null && _optional.text.trim().isNotEmpty) {
      if (!_commitOptional()) return;
    }
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      Client(
        name: _name.text.trim(),
        description: _description.text.trim(),
        status: _status,
        notes: const [],
        mobile: _added[_Optional.mobile],
        email: _added[_Optional.email],
        website: _added[_Optional.website],
        twitter: _added[_Optional.twitter],
        instagram: _added[_Optional.instagram],
        facebook: _added[_Optional.facebook],
      ),
    );
  }

  InputDecoration _decoration(
    ColorScheme scheme, {
    String? hint,
    String? error,
    Widget? prefixIcon,
  }) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1.0, color: color),
        );

    return InputDecoration(
      hintText: hint,
      errorText: error,
      prefixIcon: prefixIcon,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      border: border(scheme.onSurface),
      enabledBorder: border(scheme.onSurface),
      focusedBorder: border(scheme.secondary),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error),
    );
  }

  ButtonStyle _primaryButton(ColorScheme scheme) => ElevatedButton.styleFrom(
        backgroundColor: scheme.secondary,
        foregroundColor: scheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final remaining =
        _Optional.values.where((f) => !_added.containsKey(f)).toList();

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Client',
                      style: text.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Added optional details, shown at the top.
                        if (_added.isNotEmpty) ...[
                          for (final e in _added.entries)
                            _AddedRow(
                              field: e.key,
                              value: e.value,
                              onRemove: () =>
                                  setState(() => _added.remove(e.key)),
                            ),
                          const SizedBox(height: 12),
                        ],

                        // Required fields.
                        const _FieldLabel('Name'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: scheme.onSurface,
                          decoration:
                              _decoration(scheme, hint: 'Client name'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel('Status'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _status,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10.0),
                          decoration: _decoration(scheme),
                          items: _statuses
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _status = v);
                          },
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel('Description'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _description,
                          minLines: 3,
                          maxLines: 6,
                          cursorColor: scheme.onSurface,
                          decoration: _decoration(
                            scheme,
                            hint: 'What does this client need?',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Description is required'
                              : null,
                        ),

                        // Optional fields, added on demand.
                        if (remaining.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const _FieldLabel('Add more details'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final f in remaining)
                                ActionChip(
                                  avatar: Icon(
                                    _adding == f ? Icons.remove : Icons.add,
                                    size: 18,
                                  ),
                                  label: Text(f.label),
                                  backgroundColor: _adding == f
                                      ? scheme.secondaryContainer
                                      : null,
                                  onPressed: () => _startAdding(f),
                                ),
                            ],
                          ),
                        ],
                        if (_adding != null) ...[
                          const SizedBox(height: 16),
                          _FieldLabel(_adding!.label),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  key: ValueKey(_adding),
                                  controller: _optional,
                                  autofocus: true,
                                  keyboardType: _adding!.keyboard,
                                  cursorColor: scheme.onSurface,
                                  onSubmitted: (_) => _commitOptional(),
                                  onChanged: (_) {
                                    if (_optionalError != null) {
                                      setState(() => _optionalError = null);
                                    }
                                  },
                                  decoration: _decoration(
                                    scheme,
                                    hint: _adding!.hint,
                                    error: _optionalError,
                                    prefixIcon:
                                        Icon(_adding!.icon, size: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _commitOptional,
                                  style: _primaryButton(scheme),
                                  child: const Text('Add'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _save,
                    style: _primaryButton(scheme),
                    child: const Text('Save Client'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.error,
                      foregroundColor: scheme.onError,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Cancel'),
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

/// A value the user has added, with a remove button next to it.
class _AddedRow extends StatelessWidget {
  const _AddedRow({
    required this.field,
    required this.value,
    required this.onRemove,
  });

  final _Optional field;
  final String value;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(field.icon, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style:
                      text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove ${field.label}',
            onPressed: onRemove,
            icon: Icon(Icons.remove_circle_outline, color: scheme.error),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}