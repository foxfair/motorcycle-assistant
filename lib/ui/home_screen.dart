import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers.dart';
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
  Widget build(BuildContext context) {
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
