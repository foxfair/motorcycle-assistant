import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database/database.dart';
import 'database/repository.dart';
import 'services/fuel_calculator.dart';
import 'services/maintenance_reminder.dart';

/// Provider for the single database instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider for the repository, which depends on the database.
final repositoryProvider = Provider<GarageRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return GarageRepository(db);
});

/// Provider for the stream of all motorcycles.
final motorcyclesProvider = StreamProvider<List<Motorcycle>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchMotorcycles();
});

/// Notifier to manage the active/selected motorcycle state.
class SelectedMotorcycle extends Notifier<Motorcycle?> {
  @override
  Motorcycle? build() => null;

  void select(Motorcycle motorcycle) {
    state = motorcycle;
  }

  void clear() {
    state = null;
  }
}

/// Provider for the currently selected motorcycle.
final selectedMotorcycleProvider = NotifierProvider<SelectedMotorcycle, Motorcycle?>(SelectedMotorcycle.new);

// ============================================================================
// Bike-Specific Family Providers
// ============================================================================

/// Stream provider for the latest mileage of a specific bike.
final latestMileageProvider = StreamProvider.family<int, int>((ref, bikeId) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchLatestMileage(bikeId);
});

/// Stream provider for maintenance logs of a specific bike.
final maintenanceLogsProvider = StreamProvider.family<List<MaintenanceLog>, int>((ref, bikeId) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchMaintenanceLogs(bikeId);
});

/// Stream provider for fuel logs of a specific bike.
final fuelLogsProvider = StreamProvider.family<List<FuelLog>, int>((ref, bikeId) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchFuelLogs(bikeId);
});

/// Stream provider for parts of a specific bike.
final partsProvider = StreamProvider.family<List<Part>, int>((ref, bikeId) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchParts(bikeId);
});

// ============================================================================
// Computed Providers for Dashboard Stats
// ============================================================================

/// Provider for active maintenance reminders for a specific bike.
/// Returns null if logs or mileage are still loading.
final remindersProvider = Provider.family<List<MaintenanceReminder>?, int>((ref, bikeId) {
  final mileageAsync = ref.watch(latestMileageProvider(bikeId));
  final logsAsync = ref.watch(maintenanceLogsProvider(bikeId));

  if (mileageAsync.isLoading || logsAsync.isLoading) {
    return null;
  }

  final mileage = mileageAsync.value ?? 0;
  final logs = logsAsync.value ?? [];

  return MaintenanceReminderService.getReminders(
    currentMileage: mileage,
    logs: logs,
  );
});

/// Container class for fuel stats.
class FuelStats {
  final double? latestEconomy;
  final double? averageEconomy;
  final double totalSpend;
  final double? costPerMile;

  FuelStats({
    this.latestEconomy,
    this.averageEconomy,
    this.totalSpend = 0.0,
    this.costPerMile,
  });
}

/// Provider to calculate fuel stats (latest/average economy, spend, cost per mile) for a specific bike.
/// Returns null if fuel logs are still loading.
final fuelStatsProvider = Provider.family<FuelStats?, int>((ref, bikeId) {
  final logsAsync = ref.watch(fuelLogsProvider(bikeId));

  if (logsAsync.isLoading) {
    return null;
  }

  final logs = logsAsync.value ?? [];
  if (logs.isEmpty) {
    return FuelStats();
  }

  // 1. Calculate total spend and average price paid
  double totalSpend = 0.0;
  double totalFuelForPrice = 0.0;
  double totalSpendForPrice = 0.0;

  for (final log in logs) {
    if (log.pricePerUnit != null) {
      final spend = log.amount * log.pricePerUnit!;
      totalSpend += spend;
      totalFuelForPrice += log.amount;
      totalSpendForPrice += spend;
    }
  }

  // 2. Calculate latest economy
  final latestLog = logs.first; // sorted descending (newest first)
  final latestEconomy = FuelCalculator.calculateEconomy(latestLog, logs);

  // 3. Calculate average economy over all history
  double? averageEconomy;
  final fullFills = logs.where((log) => log.fullTank).toList();
  if (fullFills.length >= 2) {
    final newestFull = fullFills.first;
    final oldestFull = fullFills.last;
    final distance = newestFull.mileage - oldestFull.mileage;

    if (distance > 0) {
      final newestIndex = logs.indexOf(newestFull);
      final oldestIndex = logs.indexOf(oldestFull);
      double totalFuel = 0;
      for (int i = newestIndex; i < oldestIndex; i++) {
        totalFuel += logs[i].amount;
      }
      if (totalFuel > 0) {
        averageEconomy = distance / totalFuel;
      }
    }
  }

  // 4. Calculate cost per mile
  double? costPerMile;
  if (averageEconomy != null && averageEconomy > 0 && totalFuelForPrice > 0) {
    final averagePricePerUnit = totalSpendForPrice / totalFuelForPrice;
    costPerMile = averagePricePerUnit / averageEconomy;
  }

  return FuelStats(
    latestEconomy: latestEconomy,
    averageEconomy: averageEconomy,
    totalSpend: totalSpend,
    costPerMile: costPerMile,
  );
});
