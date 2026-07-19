import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// 1. Motorcycles Table (Garage)
class Motorcycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nickname => text()();
  TextColumn get make => text().nullable()();
  TextColumn get model => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get vin => text().nullable()();
  TextColumn get notes => text().nullable()();
}

// 2. Maintenance Logs Table (Linked to Motorcycle)
class MaintenanceLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)(); // Foreign Key
  DateTimeColumn get date => dateTime()();
  IntColumn get mileage => integer()();
  TextColumn get task => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get nextMaintenanceMileage => integer().nullable()();
  DateTimeColumn get nextMaintenanceDate => dateTime().nullable()();
}

// 3. Fuel and Mileage Logs Table (Linked to Motorcycle)
class FuelLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)(); // Foreign Key
  DateTimeColumn get date => dateTime()();
  IntColumn get mileage => integer()();
  RealColumn get amount => real()();
  RealColumn get pricePerUnit => real().nullable()();
  BoolColumn get fullTank => boolean().withDefault(const Constant(true))();
}

// 4. Parts and Upgrades Tracking Table (Linked to Motorcycle)
class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)(); // Foreign Key
  TextColumn get name => text()();
  TextColumn get status => text()(); // in-processing, ordered, delivered, installed
  BoolColumn get isOemPossessed => boolean().withDefault(const Constant(true))();
  IntColumn get installedMileage => integer().nullable()();
  DateTimeColumn get installedDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}

@DriftDatabase(tables: [Motorcycles, MaintenanceLogs, FuelLogs, Parts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.connect(QueryExecutor connection) : super(connection);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
