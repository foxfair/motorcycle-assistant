import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, isNotNull;
import '../database/database.dart';
import '../providers.dart';
import '../services/fuel_calculator.dart';

class LogsTab extends ConsumerStatefulWidget {
  final Motorcycle motorcycle;
  const LogsTab({super.key, required this.motorcycle});

  @override
  ConsumerState<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends ConsumerState<LogsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Rebuild to update FAB
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.outline,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Maintenance', icon: Icon(Icons.build)),
          Tab(text: 'Fuel Logs', icon: Icon(Icons.local_gas_station)),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MaintenanceLogsList(motorcycle: widget.motorcycle),
          _FuelLogsList(motorcycle: widget.motorcycle),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              key: const ValueKey('add_maint_button'),
              onPressed: () => _showAddMaintDialog(context),
              tooltip: 'Log Maintenance',
              child: const Icon(Icons.add_task),
            )
          : FloatingActionButton(
              key: const ValueKey('add_fuel_button'),
              onPressed: () => _showAddFuelDialog(context),
              tooltip: 'Log Refuel',
              child: const Icon(Icons.add_road),
            ),
    );
  }

  void _showAddMaintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddMaintDialog(motorcycle: widget.motorcycle),
    );
  }

  void _showAddFuelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddFuelDialog(motorcycle: widget.motorcycle),
    );
  }
}

// ============================================================================
// Maintenance Logs List
// ============================================================================
class _MaintenanceLogsList extends ConsumerWidget {
  final Motorcycle motorcycle;
  const _MaintenanceLogsList({required this.motorcycle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(maintenanceLogsProvider(motorcycle.id));

    return logsAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return const Center(
            child: Text('No maintenance logs recorded.', style: TextStyle(color: Colors.grey)),
          );
        }
        return ListView.builder(
          itemCount: logs.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final log = logs[index];
            final dateStr = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
            
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(log.task, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Date: $dateStr  |  Mileage: ${log.mileage} mi'),
                    if (log.notes != null && log.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('Notes: ${log.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
                    ],
                    if (log.nextMaintenanceMileage != null || log.nextMaintenanceDate != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Next Service: ' +
                            [
                              if (log.nextMaintenanceMileage != null) '${log.nextMaintenanceMileage} mi',
                              if (log.nextMaintenanceDate != null)
                                '${log.nextMaintenanceDate!.year}-${log.nextMaintenanceDate!.month.toString().padLeft(2, '0')}-${log.nextMaintenanceDate!.day.toString().padLeft(2, '0')}',
                            ].join(' / '),
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                      ),
                    ]
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, ref, log),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, MaintenanceLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Log?'),
        content: const Text('Are you sure you want to delete this maintenance entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(repositoryProvider).deleteMaintenanceLog(log.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Fuel Logs List
// ============================================================================
class _FuelLogsList extends ConsumerWidget {
  final Motorcycle motorcycle;
  const _FuelLogsList({required this.motorcycle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(fuelLogsProvider(motorcycle.id));

    return logsAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return const Center(
            child: Text('No fuel logs recorded.', style: TextStyle(color: Colors.grey)),
          );
        }
        return ListView.builder(
          itemCount: logs.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final log = logs[index];
            final dateStr = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
            
            // Calculate economy for this log entry dynamically
            final economy = FuelCalculator.calculateEconomy(log, logs);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: log.fullTank
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceVariant,
                  child: Icon(
                    log.fullTank ? Icons.local_gas_station : Icons.format_color_fill,
                    color: log.fullTank
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${log.amount.toStringAsFixed(2)} gal', style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (economy != null)
                      Text(
                        '${economy.toStringAsFixed(1)} MPG',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Date: $dateStr  |  Odometer: ${log.mileage} mi'),
                    if (log.pricePerUnit != null)
                      Text('Price: \$${log.pricePerUnit!.toStringAsFixed(2)}/gal  |  Total: \$${(log.pricePerUnit! * log.amount).toStringAsFixed(2)}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, ref, log),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, FuelLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Log?'),
        content: const Text('Are you sure you want to delete this fuel entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(repositoryProvider).deleteFuelLog(log.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Add Maintenance Dialog Form
// ============================================================================
class AddMaintDialog extends ConsumerStatefulWidget {
  final Motorcycle motorcycle;
  const AddMaintDialog({super.key, required this.motorcycle});

  @override
  ConsumerState<AddMaintDialog> createState() => _AddMaintDialogState();
}

class _AddMaintDialogState extends ConsumerState<AddMaintDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mileageController = TextEditingController();
  final _customTaskController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Overrides
  final _overrideMileageController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  DateTime? _overrideDate;
  
  String _selectedTask = 'Oil Change';
  bool _showCustomTaskField = false;
  bool _showOverrides = false;

  final List<String> _defaultTasks = [
    'Oil Change',
    'Chain Lubrication',
    'Air Filter Replacement',
    'Spark Plugs Replacement',
    'Tire Replacement',
    'Brake Pad Replacement',
    'Other'
  ];

  @override
  void dispose() {
    _mileageController.dispose();
    _customTaskController.dispose();
    _notesController.dispose();
    _overrideMileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    final overrideDateStr = _overrideDate == null
        ? 'Select Date'
        : '${_overrideDate!.year}-${_overrideDate!.month.toString().padLeft(2, '0')}-${_overrideDate!.day.toString().padLeft(2, '0')}';

    return AlertDialog(
      title: const Text('Log Maintenance'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Task Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTask,
                decoration: const InputDecoration(labelText: 'Task *'),
                items: _defaultTasks.map((task) {
                  return DropdownMenuItem(value: task, child: Text(task));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedTask = val;
                      _showCustomTaskField = val == 'Other';
                    });
                  }
                },
              ),
              if (_showCustomTaskField) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _customTaskController,
                  decoration: const InputDecoration(labelText: 'Custom Task Name *'),
                  validator: (value) {
                    if (_showCustomTaskField && (value == null || value.trim().isEmpty)) {
                      return 'Please enter a task name';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 8),
              // Mileage
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Odometer (mi) *'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter mileage';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // Date Picker Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date: $dateStr'),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              
              // Custom Due Overrides Expandable
              ExpansionTile(
                title: const Text('Custom Reminders (Optional)', style: TextStyle(fontSize: 14)),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _showOverrides = expanded;
                  });
                },
                children: [
                  TextFormField(
                    controller: _overrideMileageController,
                    decoration: const InputDecoration(labelText: 'Next Due Odometer (mi)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_showOverrides && value != null && value.isNotEmpty) {
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid integer';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Next Due Date: $overrideDateStr'),
                      TextButton(
                        onPressed: () => _pickOverrideDate(context),
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                ],
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
              final taskName = _showCustomTaskField ? _customTaskController.text.trim() : _selectedTask;
              final mileage = int.parse(_mileageController.text);
              final overrideMileage = int.tryParse(_overrideMileageController.text);

              final companion = MaintenanceLogsCompanion(
                motorcycleId: Value(widget.motorcycle.id),
                date: Value(_selectedDate),
                mileage: Value(mileage),
                task: Value(taskName),
                notes: _notesController.text.trim().isEmpty ? const Value.absent() : Value(_notesController.text.trim()),
                nextMaintenanceMileage: overrideMileage == null ? const Value.absent() : Value(overrideMileage),
                nextMaintenanceDate: _overrideDate == null ? const Value.absent() : Value(_overrideDate),
              );

              await ref.read(repositoryProvider).addMaintenanceLog(companion);
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
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickOverrideDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _overrideDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _overrideDate = picked;
      });
    }
  }
}

// ============================================================================
// Add Fuel Log Dialog Form
// ============================================================================
class AddFuelDialog extends ConsumerStatefulWidget {
  final Motorcycle motorcycle;
  const AddFuelDialog({super.key, required this.motorcycle});

  @override
  ConsumerState<AddFuelDialog> createState() => _AddFuelDialogState();
}

class _AddFuelDialogState extends ConsumerState<AddFuelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mileageController = TextEditingController();
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  bool _fullTank = true;

  @override
  void dispose() {
    _mileageController.dispose();
    _amountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

    return AlertDialog(
      title: const Text('Log Refuel'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mileage
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Odometer (mi) *'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter mileage';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // Fuel Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount (gallons) *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // Price per Unit
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price per gallon (\$, optional)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // Full Tank Toggle
              SwitchListTile(
                title: const Text('Full Tank?', style: TextStyle(fontSize: 15)),
                value: _fullTank,
                onChanged: (val) {
                  setState(() {
                    _fullTank = val;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              // Date picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date: $dateStr'),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
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
              final mileage = int.parse(_mileageController.text);
              final amount = double.parse(_amountController.text);
              final price = double.tryParse(_priceController.text);

              final companion = FuelLogsCompanion(
                motorcycleId: Value(widget.motorcycle.id),
                date: Value(_selectedDate),
                mileage: Value(mileage),
                amount: Value(amount),
                pricePerUnit: price == null ? const Value.absent() : Value(price),
                fullTank: Value(_fullTank),
              );

              await ref.read(repositoryProvider).addFuelLog(companion);
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
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
