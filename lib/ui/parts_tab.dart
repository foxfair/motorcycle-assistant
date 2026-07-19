import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, isNotNull;
import '../database/database.dart';
import '../providers.dart';

class PartsTab extends ConsumerWidget {
  final Motorcycle motorcycle;
  const PartsTab({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partsAsync = ref.watch(partsProvider(motorcycle.id));

    return Scaffold(
      body: partsAsync.when(
        data: (parts) {
          if (parts.isEmpty) {
            return const Center(
              child: Text('No parts tracked yet. Add your first upgrade!', style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.builder(
            itemCount: parts.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final part = parts[index];
              return _buildPartCard(context, ref, part);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('add_part_button'),
        onPressed: () => _showAddPartDialog(context),
        tooltip: 'Track Part/Upgrade',
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  Widget _buildPartCard(BuildContext context, WidgetRef ref, Part part) {
    Color statusColor;
    switch (part.status) {
      case 'In-progress':
        statusColor = Colors.grey;
        break;
      case 'Ordered':
        statusColor = Colors.orange;
        break;
      case 'Delivered':
        statusColor = Colors.blue;
        break;
      case 'Installed':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.black;
    }

    final dateStr = part.installedDate == null
        ? ''
        : '${part.installedDate!.year}-${part.installedDate!.month.toString().padLeft(2, '0')}-${part.installedDate!.day.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(part.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Chip(
              label: Text(part.status, style: const TextStyle(fontSize: 11, color: Colors.white)),
              backgroundColor: statusColor,
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  part.isOemPossessed ? Icons.check_box : Icons.disabled_by_default,
                  size: 16,
                  color: part.isOemPossessed ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  part.isOemPossessed ? 'OEM Part Retained' : 'No OEM Part Retained',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            if (part.status == 'Installed') ...[
              const SizedBox(height: 4),
              Text(
                'Installed @ ${part.installedMileage ?? 0} mi' + (dateStr.isNotEmpty ? ' on $dateStr' : ''),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
            if (part.notes != null && part.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Notes: ${part.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditPartDialog(context, part),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, ref, part),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PartFormDialog(motorcycle: motorcycle),
    );
  }

  void _showEditPartDialog(BuildContext context, Part part) {
    showDialog(
      context: context,
      builder: (context) => PartFormDialog(motorcycle: motorcycle, part: part),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Part part) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tracked Part?'),
        content: Text('Are you sure you want to stop tracking "${part.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(repositoryProvider).deletePart(part.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Add/Edit Part Dialog Form
// ============================================================================
class PartFormDialog extends ConsumerStatefulWidget {
  final Motorcycle motorcycle;
  final Part? part; // Null if adding, non-null if editing
  const PartFormDialog({super.key, required this.motorcycle, this.part});

  @override
  ConsumerState<PartFormDialog> createState() => _PartFormDialogState();
}

class _PartFormDialogState extends ConsumerState<PartFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _mileageController = TextEditingController();

  String _status = 'In-progress';
  bool _isOemPossessed = false;
  DateTime? _installedDate;
  bool _logAsMaintenance = true; // Auto-log to maintenance when installed

  final List<String> _statuses = ['In-progress', 'Ordered', 'Delivered', 'Installed'];

  @override
  void initState() {
    super.initState();
    if (widget.part != null) {
      _nameController.text = widget.part!.name;
      _notesController.text = widget.part!.notes ?? '';
      _status = widget.part!.status;
      _isOemPossessed = widget.part!.isOemPossessed;
      _installedDate = widget.part!.installedDate;
      _mileageController.text = widget.part!.installedMileage?.toString() ?? '';
      _logAsMaintenance = false; // Disable default auto-log when editing to avoid duplicates
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _installedDate == null
        ? 'Select Date'
        : '${_installedDate!.year}-${_installedDate!.month.toString().padLeft(2, '0')}-${_installedDate!.day.toString().padLeft(2, '0')}';

    final isEdit = widget.part != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Part' : 'Track Part/Upgrade'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Part Name *', hintText: 'e.g. Yoshimura Exhaust'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter part name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: _statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _status = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('OEM Part Retained?', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Do you still possess the original OEM part?', style: TextStyle(fontSize: 11)),
                value: _isOemPossessed,
                onChanged: (val) {
                  setState(() {
                    _isOemPossessed = val;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),

              // Installation details (only visible if status is Installed)
              if (_status == 'Installed') ...[
                const Divider(),
                const Text('Installation Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _mileageController,
                  decoration: const InputDecoration(labelText: 'Installation Odometer (mi) *'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_status == 'Installed' && (value == null || value.trim().isEmpty)) {
                      return 'Please enter mileage at installation';
                    }
                    if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                      return 'Please enter a valid integer';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Install Date: $dateStr'),
                    TextButton(
                      onPressed: () => _pickDate(context),
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                if (!isEdit) ...[
                  CheckboxListTile(
                    title: const Text('Log as Maintenance Event?', style: TextStyle(fontSize: 13)),
                    subtitle: const Text('Adds this installation to your maintenance logs automatically.', style: TextStyle(fontSize: 11)),
                    value: _logAsMaintenance,
                    onChanged: (val) {
                      setState(() {
                        _logAsMaintenance = val ?? true;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ],
              const Divider(),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final name = _nameController.text.trim();
              final mileage = int.tryParse(_mileageController.text);
              final notes = _notesController.text.trim();

              final partsCompanion = PartsCompanion(
                id: isEdit ? Value(widget.part!.id) : const Value.absent(),
                motorcycleId: Value(widget.motorcycle.id),
                name: Value(name),
                status: Value(_status),
                isOemPossessed: Value(_isOemPossessed),
                installedMileage: _status == 'Installed' && mileage != null ? Value(mileage) : const Value.absent(),
                installedDate: _status == 'Installed' && _installedDate != null ? Value(_installedDate) : const Value.absent(),
                notes: notes.isEmpty ? const Value.absent() : Value(notes),
              );

              final repo = ref.read(repositoryProvider);

              if (isEdit) {
                // Update
                final updatedPart = Part(
                  id: widget.part!.id,
                  motorcycleId: widget.motorcycle.id,
                  name: name,
                  status: _status,
                  isOemPossessed: _isOemPossessed,
                  installedMileage: _status == 'Installed' ? mileage : null,
                  installedDate: _status == 'Installed' ? _installedDate : null,
                  notes: notes.isEmpty ? null : notes,
                );
                await repo.updatePart(updatedPart);
              } else {
                // Add
                await repo.addPart(partsCompanion);

                // Auto-log to maintenance if checked
                if (_status == 'Installed' && _logAsMaintenance && mileage != null) {
                  final maintCompanion = MaintenanceLogsCompanion(
                    motorcycleId: Value(widget.motorcycle.id),
                    date: Value(_installedDate ?? DateTime.now()),
                    mileage: Value(mileage),
                    task: Value('Installed: $name'),
                    notes: Value(notes.isEmpty ? 'Automated part installation log.' : 'Part notes: $notes'),
                  );
                  await repo.addMaintenanceLog(maintCompanion);
                }
              }

              if (mounted) {
                Navigator.pop(context);
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _installedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _installedDate = picked;
      });
    }
  }
}
