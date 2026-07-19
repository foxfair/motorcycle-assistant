import 'package:flutter_test/flutter_test.dart';
import 'package:motorcycle_assistant/database/database.dart';
import 'package:motorcycle_assistant/services/maintenance_reminder.dart';

void main() {
  // Helper to create a MaintenanceLog
  MaintenanceLog createLog({
    required int id,
    required String task,
    required DateTime date,
    required int mileage,
    int? nextMaintenanceMileage,
    DateTime? nextMaintenanceDate,
  }) {
    return MaintenanceLog(
      id: id,
      motorcycleId: 1,
      date: date,
      mileage: mileage,
      task: task,
      nextMaintenanceMileage: nextMaintenanceMileage,
      nextMaintenanceDate: nextMaintenanceDate,
    );
  }

  // Single test config for simplicity in some tests
  const testConfig = MaintenanceTaskConfig(
    taskName: 'Oil Change',
    mileageInterval: 4000,
    timeInterval: Duration(days: 180), // 6 months
  );

  group('MaintenanceReminderService.getReminders Tests', () {
    test('Should return unknown status if no history exists for the task', () {
      final reminders = MaintenanceReminderService.getReminders(
        currentMileage: 5000,
        logs: [], // No logs
        configs: [testConfig],
      );

      expect(reminders.length, 1);
      expect(reminders.first.status, MaintenanceStatus.unknown);
      expect(reminders.first.reason, 'Never recorded.');
    });

    test('Should return clean status if maintenance was done recently', () {
      final log = createLog(
        id: 1,
        task: 'Oil Change',
        date: DateTime(2026, 7, 1),
        mileage: 1000,
      );

      final reminders = MaintenanceReminderService.getReminders(
        currentMileage: 2000, // Only 1000 miles since last change
        logs: [log],
        configs: [testConfig],
        now: DateTime(2026, 7, 15), // Only 14 days since last change
      );

      expect(reminders.first.status, MaintenanceStatus.clean);
      expect(reminders.first.nextDueMileage, 5000); // 1000 + 4000
      expect(reminders.first.nextDueRawDate, DateTime(2026, 7, 1).add(const Duration(days: 180)));
      expect(reminders.first.reason, contains('Next: Due at 5000 mi'));
    });

    test('Should return dueSoon status if close to mileage limit', () {
      final log = createLog(
        id: 1,
        task: 'Oil Change',
        date: DateTime(2026, 7, 1),
        mileage: 1000,
      );

      final reminders = MaintenanceReminderService.getReminders(
        currentMileage: 4700, // 3700 miles since last (due at 5000, within 10% of 4000 interval)
        logs: [log],
        configs: [testConfig],
        now: DateTime(2026, 7, 15),
      );

      expect(reminders.first.status, MaintenanceStatus.dueSoon);
      expect(reminders.first.reason, contains('Due in 300 mi'));
    });

    test('Should return dueSoon status if close to time limit', () {
      final log = createLog(
        id: 1,
        task: 'Oil Change',
        date: DateTime(2026, 1, 1),
        mileage: 1000,
      );

      final reminders = MaintenanceReminderService.getReminders(
        currentMileage: 2000,
        logs: [log],
        configs: [testConfig],
        now: DateTime(2026, 6, 15), // ~15 days before due date (June 30th)
      );

      expect(reminders.first.status, MaintenanceStatus.dueSoon);
      expect(reminders.first.reason, contains('Due in 15 days'));
    });

    test('Should return overdue status if past mileage limit', () {
      final log = createLog(
        id: 1,
        task: 'Oil Change',
        date: DateTime(2026, 7, 1),
        mileage: 1000,
      );

      final reminders = MaintenanceReminderService.getReminders(
        currentMileage: 5100, // Past 5000
        logs: [log],
        configs: [testConfig],
        now: DateTime(2026, 7, 15),
      );

      expect(reminders.first.status, MaintenanceStatus.overdue);
      expect(reminders.first.reason, contains('Overdue by 100 mi'));
    });

    test('Should return overdue status if past time limit', () {
      final log = createLog(
        id: 1,
        task: 'Oil Change',
        date: DateTime(2026, 1, 1),
        mileage: 1000,
      );

      final reminders = MaintenanceReminderService.getReminders(
        currentMileage: 2000,
        logs: [log],
        configs: [testConfig],
        now: DateTime(2026, 7, 5), // Past June 30th
      );

      expect(reminders.first.status, MaintenanceStatus.overdue);
      expect(reminders.first.reason, contains('Overdue by 5 days'));
    });

    test('Should respect user manual override for next due mileage and date', () {
      final log = createLog(
        id: 1,
        task: 'Oil Change',
        date: DateTime(2026, 7, 1),
        mileage: 1000,
        nextMaintenanceMileage: 3000, // Custom override (default would be 5000)
        nextMaintenanceDate: DateTime(2026, 8, 1), // Custom override (default would be late Dec)
      );

      final reminders = MaintenanceReminderService.getReminders(
        currentMileage: 2700, // Not due by default, but due soon by override (3000)
        logs: [log],
        configs: [testConfig],
        now: DateTime(2026, 7, 15), // Not due by default, but due soon by override (Aug 1)
      );

      expect(reminders.first.nextDueMileage, 3000);
      expect(reminders.first.nextDueRawDate, DateTime(2026, 8, 1));
      expect(reminders.first.status, MaintenanceStatus.dueSoon);
      expect(reminders.first.reason, contains('Due in 300 mi and Due in 17 days'));
    });
  });
}
