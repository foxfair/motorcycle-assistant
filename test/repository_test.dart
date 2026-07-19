import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:motorcycle_assistant/database/database.dart';
import 'package:motorcycle_assistant/database/repository.dart';

void main() {
  open.overrideFor(OperatingSystem.linux, () {
    return DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0');
  });

  late AppDatabase database;
  late GarageRepository repository;

  setUp(() {
    // Use in-memory database for testing
    database = AppDatabase.connect(NativeDatabase.memory());
    repository = GarageRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Motorcycle CRUD Tests', () {
    test('Can add, read, update, and delete motorcycles', () async {
      // 1. Verify initially empty
      var bikes = await repository.getMotorcycles();
      expect(bikes, isEmpty);

      // 2. Add a motorcycle
      final id = await repository.addMotorcycle(
        const MotorcyclesCompanion(
          nickname: Value('Tiger'),
          make: Value('Triumph'),
          model: Value('Tiger 900'),
          year: Value(2021),
        ),
      );
      expect(id, isNotNull);

      // 3. Read and verify
      bikes = await repository.getMotorcycles();
      expect(bikes.length, 1);
      expect(bikes.first.nickname, 'Tiger');
      expect(bikes.first.id, id);

      // 4. Update
      final updatedBike = bikes.first.copyWith(nickname: 'Tiger Explorer');
      final updated = await repository.updateMotorcycle(updatedBike);
      expect(updated, true);

      bikes = await repository.getMotorcycles();
      expect(bikes.first.nickname, 'Tiger Explorer');

      // 5. Delete
      final deleted = await repository.deleteMotorcycle(id);
      expect(deleted, 1);

      bikes = await repository.getMotorcycles();
      expect(bikes, isEmpty);
    });
  });

  group('Maintenance Logs CRUD Tests', () {
    test('Can add, read, update, and delete maintenance logs for a bike', () async {
      // Add a bike first
      final bikeId = await repository.addMotorcycle(
        const MotorcyclesCompanion(nickname: Value('Africa Twin')),
      );

      // Verify no logs initially
      var logs = await repository.watchMaintenanceLogs(bikeId).first;
      expect(logs, isEmpty);

      // Add a log
      final logId = await repository.addMaintenanceLog(
        MaintenanceLogsCompanion(
          motorcycleId: Value(bikeId),
          date: Value(DateTime(2026, 7, 18)),
          mileage: const Value(5000),
          task: const Value('Oil Change'),
          notes: const Value('Shell Rotella T6'),
        ),
      );

      // Verify log exists
      logs = await repository.watchMaintenanceLogs(bikeId).first;
      expect(logs.length, 1);
      expect(logs.first.id, logId);
      expect(logs.first.task, 'Oil Change');
      expect(logs.first.motorcycleId, bikeId);

      // Update log
      final updatedLog = logs.first.copyWith(task: 'Oil & Filter Change');
      final updated = await repository.updateMaintenanceLog(updatedLog);
      expect(updated, true);

      logs = await repository.watchMaintenanceLogs(bikeId).first;
      expect(logs.first.task, 'Oil & Filter Change');

      // Delete log
      final deleted = await repository.deleteMaintenanceLog(logId);
      expect(deleted, 1);

      logs = await repository.watchMaintenanceLogs(bikeId).first;
      expect(logs, isEmpty);
    });
  });

  group('Fuel Logs CRUD Tests', () {
    test('Can add, read, update, and delete fuel logs for a bike', () async {
      // Add a bike first
      final bikeId = await repository.addMotorcycle(
        const MotorcyclesCompanion(nickname: Value('Bolt')),
      );

      // Verify no logs initially
      var logs = await repository.watchFuelLogs(bikeId).first;
      expect(logs, isEmpty);

      // Add a log
      final logId = await repository.addFuelLog(
        FuelLogsCompanion(
          motorcycleId: Value(bikeId),
          date: Value(DateTime(2026, 7, 18)),
          mileage: const Value(1000),
          amount: const Value(3.2),
          pricePerUnit: const Value(4.5),
        ),
      );

      // Verify log exists
      logs = await repository.watchFuelLogs(bikeId).first;
      expect(logs.length, 1);
      expect(logs.first.id, logId);
      expect(logs.first.amount, 3.2);

      // Update log
      final updatedLog = logs.first.copyWith(amount: 3.5);
      final updated = await repository.updateFuelLog(updatedLog);
      expect(updated, true);

      logs = await repository.watchFuelLogs(bikeId).first;
      expect(logs.first.amount, 3.5);

      // Delete log
      final deleted = await repository.deleteFuelLog(logId);
      expect(deleted, 1);

      logs = await repository.watchFuelLogs(bikeId).first;
      expect(logs, isEmpty);
    });
  });

  group('Parts CRUD Tests', () {
    test('Can add, read, update, and delete parts for a bike', () async {
      // Add a bike first
      final bikeId = await repository.addMotorcycle(
        const MotorcyclesCompanion(nickname: Value('Grom')),
      );

      // Verify no parts initially
      var parts = await repository.watchParts(bikeId).first;
      expect(parts, isEmpty);

      // Add a part
      final partId = await repository.addPart(
        PartsCompanion(
          motorcycleId: Value(bikeId),
          name: const Value('Yoshimura Exhaust'),
          status: const Value('ordered'),
          isOemPossessed: const Value(true),
        ),
      );

      // Verify part exists
      parts = await repository.watchParts(bikeId).first;
      expect(parts.length, 1);
      expect(parts.first.id, partId);
      expect(parts.first.name, 'Yoshimura Exhaust');

      // Update part
      final updatedPart = parts.first.copyWith(status: 'installed');
      final updated = await repository.updatePart(updatedPart);
      expect(updated, true);

      parts = await repository.watchParts(bikeId).first;
      expect(parts.first.status, 'installed');

      // Delete part
      final deleted = await repository.deletePart(partId);
      expect(deleted, 1);

      parts = await repository.watchParts(bikeId).first;
      expect(parts, isEmpty);
    });
  });

  group('Utility/Calculation Tests', () {
    test('watchLatestMileage returns correct max mileage', () async {
      final bikeId = await repository.addMotorcycle(
        const MotorcyclesCompanion(nickname: Value('Test Bike')),
      );

      // Initial mileage should be 0 (no logs)
      var mileage = await repository.watchLatestMileage(bikeId).first;
      expect(mileage, equals(0));

      // Add maintenance log @ 1000 mi
      await repository.addMaintenanceLog(
        MaintenanceLogsCompanion(
          motorcycleId: Value(bikeId),
          date: Value(DateTime.now()),
          mileage: const Value(1000),
          task: const Value('Oil Change'),
        ),
      );

      mileage = await repository.watchLatestMileage(bikeId).first;
      expect(mileage, equals(1000));

      // Add fuel log @ 1500 mi (higher)
      await repository.addFuelLog(
        FuelLogsCompanion(
          motorcycleId: Value(bikeId),
          date: Value(DateTime.now()),
          mileage: const Value(1500),
          amount: const Value(4.0),
          fullTank: const Value(true),
        ),
      );

      mileage = await repository.watchLatestMileage(bikeId).first;
      expect(mileage, equals(1500));
    });
  });
}
