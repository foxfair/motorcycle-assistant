import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide isNotNull, Column;
import '../database/database.dart';
import '../providers.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motorcyclesAsync = ref.watch(motorcyclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Garage'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: motorcyclesAsync.when(
        data: (bikes) {
          if (bikes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Your garage is empty.\nTap the + button to add your first motorcycle!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: bikes.length,
            itemBuilder: (context, index) {
              final bike = bikes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.motorcycle),
                  ),
                  title: Text(
                    bike.nickname,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${bike.year ?? ""} ${bike.make ?? ""} ${bike.model ?? ""}'.trim(),
                  ),
                  onTap: () {
                    // Select this bike and navigate to home dashboard
                    ref.read(selectedMotorcycleProvider.notifier).select(bike);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(context, ref, bike),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBikeDialog(context, ref),
        tooltip: 'Add Motorcycle',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Motorcycle bike) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Motorcycle?'),
        content: Text('This will permanently delete "${bike.nickname}" and all its logs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(repositoryProvider).deleteMotorcycle(bike.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddBikeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const AddMotorcycleDialog(),
    );
  }
}

class AddMotorcycleDialog extends ConsumerStatefulWidget {
  const AddMotorcycleDialog({super.key});

  @override
  ConsumerState<AddMotorcycleDialog> createState() => _AddMotorcycleDialogState();
}

class _AddMotorcycleDialogState extends ConsumerState<AddMotorcycleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _vinController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _vinController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Motorcycle'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname (e.g. My Africa Twin) *',
                  hintText: 'Enter a nickname for your bike',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a nickname';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _makeController,
                decoration: const InputDecoration(labelText: 'Make (e.g. Honda)'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model (e.g. CRF1100L)'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final year = int.tryParse(value);
                    if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                      return 'Please enter a valid year';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vinController,
                decoration: const InputDecoration(labelText: 'VIN'),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 8),
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final year = int.tryParse(_yearController.text);
              final companion = MotorcyclesCompanion(
                nickname: Value(_nicknameController.text.trim()),
                make: _makeController.text.trim().isEmpty
                    ? const Value.absent()
                    : Value(_makeController.text.trim()),
                model: _modelController.text.trim().isEmpty
                    ? const Value.absent()
                    : Value(_modelController.text.trim()),
                year: year == null ? const Value.absent() : Value(year),
                vin: _vinController.text.trim().isEmpty
                    ? const Value.absent()
                    : Value(_vinController.text.trim()),
                notes: _notesController.text.trim().isEmpty
                    ? const Value.absent()
                    : Value(_notesController.text.trim()),
              );

              await ref.read(repositoryProvider).addMotorcycle(companion);
              if (mounted) {
                Navigator.pop(context);
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
