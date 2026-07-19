import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers.dart';
import '../services/maintenance_reminder.dart';
import '../services/settings_service.dart';
import '../services/unit_converter.dart';

class DashboardTab extends ConsumerWidget {
  final Motorcycle motorcycle;
  const DashboardTab({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mileageAsync = ref.watch(latestMileageProvider(motorcycle.id));
    final fuelStats = ref.watch(fuelStatsProvider(motorcycle.id));
    final reminders = ref.watch(remindersProvider(motorcycle.id));
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Re-fetching is handled automatically by streams
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Needed for RefreshIndicator to work
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Odometer Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Odometer',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 4),
                            mileageAsync.when(
                              data: (mileage) {
                                final converted = UnitConverter.convertDistance(mileage.toDouble(), settings.distanceUnit).round();
                                return Text(
                                  '$converted ${settings.distanceUnit.label}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                              loading: () => const SizedBox(
                                height: 32,
                                width: 32,
                                child: CircularProgressIndicator(strokeWidth: 3),
                              ),
                              error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.speed,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Fuel Stats Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fuel Economy',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (fuelStats == null)
                          const Center(child: CircularProgressIndicator())
                        else if (fuelStats.latestEconomy == null && fuelStats.averageEconomy == null)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'No fuel logs recorded yet (need at least 2 full fills to calculate economy).',
                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: Colors.grey),
                            ),
                          )
                        else
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem(
                                    context,
                                    'Average Economy',
                                    fuelStats.averageEconomy != null
                                        ? '${UnitConverter.convertEconomy(fuelStats.averageEconomy!, settings.economyUnit).toStringAsFixed(1)} ${settings.economyUnit.label}'
                                        : '--',
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Theme.of(context).colorScheme.outlineVariant,
                                  ),
                                  _buildStatItem(
                                    context,
                                    'Latest Economy',
                                    fuelStats.latestEconomy != null
                                        ? '${UnitConverter.convertEconomy(fuelStats.latestEconomy!, settings.economyUnit).toStringAsFixed(1)} ${settings.economyUnit.label}'
                                        : '--',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(color: Theme.of(context).colorScheme.outlineVariant),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem(
                                    context,
                                    'Total Fuel Spend',
                                    '\$${fuelStats.totalSpend.toStringAsFixed(2)}',
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Theme.of(context).colorScheme.outlineVariant,
                                  ),
                                  _buildStatItem(
                                    context,
                                    settings.distanceUnit == DistanceUnit.miles ? 'Cost per Mile' : 'Cost per Km',
                                    fuelStats.costPerMile != null
                                        ? '\$${UnitConverter.convertCostPerDistance(fuelStats.costPerMile!, settings.distanceUnit).toStringAsFixed(3)}/${settings.distanceUnit.label}'
                                        : '--',
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Maintenance Reminders Section
                const Text(
                  'Maintenance Reminders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (reminders == null)
                  const Center(child: CircularProgressIndicator())
                else if (reminders.isEmpty)
                  const Text('No maintenance tasks configured.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      return _buildReminderTile(context, reminder);
                    },
                  ),
                const SizedBox(height: 24),
                _buildVehicleInfoCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildReminderTile(BuildContext context, MaintenanceReminder reminder) {
    Color statusColor;
    IconData statusIcon;

    switch (reminder.status) {
      case MaintenanceStatus.clean:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case MaintenanceStatus.dueSoon:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case MaintenanceStatus.overdue:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case MaintenanceStatus.unknown:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 28),
        title: Text(
          reminder.taskName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(reminder.reason),
      ),
    );
  }

  Widget _buildVehicleInfoCard(BuildContext context) {
    final hasVin = motorcycle.vin != null && motorcycle.vin!.trim().isNotEmpty;
    final hasNotes = motorcycle.notes != null && motorcycle.notes!.trim().isNotEmpty;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Information',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(context, 'Nickname', motorcycle.nickname),
            _buildInfoRow(context, 'Make', motorcycle.make ?? '--'),
            _buildInfoRow(context, 'Model', motorcycle.model ?? '--'),
            _buildInfoRow(context, 'Year', motorcycle.year?.toString() ?? '--'),
            if (hasVin) _buildInfoRow(context, 'VIN', motorcycle.vin!),
            if (hasNotes) ...[
              const Divider(height: 16),
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                motorcycle.notes!,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
