import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers.dart';
import '../services/notification_service.dart';
import '../services/maintenance_reminder.dart';
import 'dashboard_tab.dart';
import 'logs_tab.dart';
import 'parts_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Motorcycle motorcycle;
  const HomeScreen({super.key, required this.motorcycle});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Request notification permissions when entering Home
    NotificationService.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to reminders and trigger notifications on status transitions (clean -> due/overdue)
    ref.listen<List<MaintenanceReminder>?>(
      remindersProvider(widget.motorcycle.id),
      (previous, next) {
        if (next == null) return;

        final prevMap = {
          for (final r in previous ?? <MaintenanceReminder>[]) r.taskName: r.status
        };

        for (final reminder in next) {
          final prevStatus = prevMap[reminder.taskName];
          final currentStatus = reminder.status;

          // Only trigger if status changed and became due/overdue
          if (currentStatus != prevStatus) {
            if (currentStatus == MaintenanceStatus.dueSoon || currentStatus == MaintenanceStatus.overdue) {
              final isOverdue = currentStatus == MaintenanceStatus.overdue;
              NotificationService.showImmediateNotification(
                id: reminder.taskName.hashCode, // Unique ID per task type
                title: '${widget.motorcycle.nickname} Maintenance Alert',
                body: '${reminder.taskName} is ${isOverdue ? "OVERDUE" : "due soon"}: ${reminder.reason}',
              );
            }
          }
        }
      },
    );
    final tabs = [
      DashboardTab(motorcycle: widget.motorcycle),
      LogsTab(motorcycle: widget.motorcycle),
      PartsTab(motorcycle: widget.motorcycle),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.motorcycle.nickname),
            Text(
              '${widget.motorcycle.year ?? ""} ${widget.motorcycle.make ?? ""} ${widget.motorcycle.model ?? ""}'.trim(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horizontal_circle_outlined),
            tooltip: 'Switch Bike',
            onPressed: () {
              // Clear selection to go back to GarageScreen
              ref.read(selectedMotorcycleProvider.notifier).clear();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_circle),
            label: 'Parts',
          ),
        ],
      ),
    );
  }
}
