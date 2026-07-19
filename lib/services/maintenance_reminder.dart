import '../database/database.dart';

enum MaintenanceStatus {
  clean,   // Maintenance is not needed soon
  dueSoon, // Maintenance is close to being due
  overdue, // Maintenance is past due
  unknown, // No history to determine status
}

class MaintenanceTaskConfig {
  final String taskName;
  final int? mileageInterval;
  final Duration? timeInterval;

  const MaintenanceTaskConfig({
    required this.taskName,
    this.mileageInterval,
    this.timeInterval,
  });
}

class MaintenanceReminder {
  final String taskName;
  final MaintenanceStatus status;
  final int? nextDueMileage;
  final DateTime? nextDueRawDate;
  final String reason;

  MaintenanceReminder({
    required this.taskName,
    required this.status,
    this.nextDueMileage,
    this.nextDueRawDate,
    required this.reason,
  });
}

class MaintenanceReminderService {
  // Default configurations for common maintenance tasks
  static const List<MaintenanceTaskConfig> defaultConfigs = [
    MaintenanceTaskConfig(
      taskName: 'Oil Change',
      mileageInterval: 4000,
      timeInterval: Duration(days: 180), // 6 months
    ),
    MaintenanceTaskConfig(
      taskName: 'Chain Lubrication',
      mileageInterval: 500,
      timeInterval: Duration(days: 30), // 1 month
    ),
    MaintenanceTaskConfig(
      taskName: 'Air Filter Replacement',
      mileageInterval: 12000,
      timeInterval: Duration(days: 365), // 1 year
    ),
    MaintenanceTaskConfig(
      taskName: 'Spark Plugs Replacement',
      mileageInterval: 12000,
      timeInterval: Duration(days: 730), // 2 years
    ),
  ];

  /// Calculates reminders for all configured tasks based on [currentMileage] and [logs].
  ///
  /// [logs] must be sorted by date in descending order (newest first).
  /// [now] can be passed to mock the current date/time in tests.
  static List<MaintenanceReminder> getReminders({
    required int currentMileage,
    required List<MaintenanceLog> logs,
    List<MaintenanceTaskConfig> configs = defaultConfigs,
    DateTime? now,
  }) {
    final referenceDate = now ?? DateTime.now();
    final List<MaintenanceReminder> reminders = [];

    for (final config in configs) {
      // Find logs matching this task (case-insensitive)
      final taskLogs = logs
          .where((log) => log.task.trim().toLowerCase() == config.taskName.trim().toLowerCase())
          .toList();

      if (taskLogs.isEmpty) {
        reminders.add(MaintenanceReminder(
          taskName: config.taskName,
          status: MaintenanceStatus.unknown,
          reason: 'Never recorded.',
        ));
        continue;
      }

      // Since logs are sorted descending by date, the first one is the latest
      final latestLog = taskLogs.first;

      int? nextDueMileage;
      DateTime? nextDueRawDate;

      // 1. Determine next due mileage (user override in log has priority)
      if (latestLog.nextMaintenanceMileage != null) {
        nextDueMileage = latestLog.nextMaintenanceMileage;
      } else if (config.mileageInterval != null) {
        nextDueMileage = latestLog.mileage + config.mileageInterval!;
      }

      // 2. Determine next due date (user override in log has priority)
      if (latestLog.nextMaintenanceDate != null) {
        nextDueRawDate = latestLog.nextMaintenanceDate;
      } else if (config.timeInterval != null) {
        nextDueRawDate = latestLog.date.add(config.timeInterval!);
      }

      // 3. Determine status
      MaintenanceStatus status = MaintenanceStatus.clean;
      List<String> overdueReasons = [];
      List<String> dueSoonReasons = [];

      if (nextDueMileage != null) {
        final remainingMileage = nextDueMileage - currentMileage;
        if (remainingMileage <= 0) {
          status = MaintenanceStatus.overdue;
          overdueReasons.add('Overdue by ${remainingMileage.abs()} mi');
        } else if (config.mileageInterval != null && remainingMileage < (config.mileageInterval! * 0.1)) {
          // Due soon if within 10% of interval
          status = MaintenanceStatus.dueSoon;
          dueSoonReasons.add('Due in $remainingMileage mi');
        }
      }

      if (nextDueRawDate != null) {
        final remainingDays = nextDueRawDate.difference(referenceDate).inDays;
        if (remainingDays <= 0) {
          status = MaintenanceStatus.overdue;
          overdueReasons.add('Overdue by ${remainingDays.abs()} days');
        } else if (remainingDays < 30) {
          // Due soon if within 30 days
          if (status != MaintenanceStatus.overdue) {
            status = MaintenanceStatus.dueSoon;
          }
          dueSoonReasons.add('Due in $remainingDays days');
        }
      }

      // 4. Construct reason string
      String reason = 'Up to date.';
      if (status == MaintenanceStatus.overdue) {
        reason = overdueReasons.join(' and ');
      } else if (status == MaintenanceStatus.dueSoon) {
        reason = dueSoonReasons.join(' and ');
      } else if (nextDueMileage != null || nextDueRawDate != null) {
        final List<String> cleanParts = [];
        if (nextDueMileage != null) {
          cleanParts.add('Due at $nextDueMileage mi');
        }
        if (nextDueRawDate != null) {
          final dateStr = '${nextDueRawDate.year}-${nextDueRawDate.month.toString().padLeft(2, '0')}-${nextDueRawDate.day.toString().padLeft(2, '0')}';
          cleanParts.add('Due by $dateStr');
        }
        reason = 'Next: ' + cleanParts.join(' / ');
      }

      reminders.add(MaintenanceReminder(
        taskName: config.taskName,
        status: status,
        nextDueMileage: nextDueMileage,
        nextDueRawDate: nextDueRawDate,
        reason: reason,
      ));
    }

    return reminders;
  }
}
