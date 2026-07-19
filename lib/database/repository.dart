import 'package:drift/drift.dart';
import 'database.dart';

class GarageRepository {
  final AppDatabase _db;

  GarageRepository(this._db);

  // ==========================================
  // 1. Motorcycle CRUD
  // ==========================================

  /// Stream of all motorcycles in the garage.
  Stream<List<Motorcycle>> watchMotorcycles() {
    return _db.select(_db.motorcycles).watch();
  }

  /// Get list of all motorcycles.
  Future<List<Motorcycle>> getMotorcycles() {
    return _db.select(_db.motorcycles).get();
  }

  /// Add a new motorcycle. Returns the generated ID.
  Future<int> addMotorcycle(MotorcyclesCompanion companion) {
    return _db.into(_db.motorcycles).insert(companion);
  }

  /// Update motorcycle details.
  Future<bool> updateMotorcycle(Motorcycle motorcycle) {
    return _db.update(_db.motorcycles).replace(motorcycle);
  }

  /// Delete a motorcycle and all its associated logs (handled by foreign keys or manually).
  /// Note: SQLite foreign keys default to NO ACTION unless ON DELETE CASCADE is specified.
  /// Drift supports ON DELETE CASCADE, but for simplicity here we just delete the bike.
  Future<int> deleteMotorcycle(int id) {
    return (_db.delete(_db.motorcycles)..where((t) => t.id.equals(id))).go();
  }

  // ==========================================
  // 2. Maintenance Logs CRUD (Filtered by Motorcycle)
  // ==========================================

  /// Stream of maintenance logs for a specific motorcycle, sorted by date (newest first).
  Stream<List<MaintenanceLog>> watchMaintenanceLogs(int motorcycleId) {
    return (_db.select(_db.maintenanceLogs)
          ..where((t) => t.motorcycleId.equals(motorcycleId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Add a new maintenance log.
  Future<int> addMaintenanceLog(MaintenanceLogsCompanion companion) {
    return _db.into(_db.maintenanceLogs).insert(companion);
  }

  /// Update a maintenance log.
  Future<bool> updateMaintenanceLog(MaintenanceLog log) {
    return _db.update(_db.maintenanceLogs).replace(log);
  }

  /// Delete a maintenance log.
  Future<int> deleteMaintenanceLog(int id) {
    return (_db.delete(_db.maintenanceLogs)..where((t) => t.id.equals(id))).go();
  }

  // ==========================================
  // 3. Fuel Logs CRUD (Filtered by Motorcycle)
  // ==========================================

  /// Stream of fuel logs for a specific motorcycle, sorted by mileage (newest/highest first).
  /// Sorting by mileage is useful for sequential MPG calculations.
  Stream<List<FuelLog>> watchFuelLogs(int motorcycleId) {
    return (_db.select(_db.fuelLogs)
          ..where((t) => t.motorcycleId.equals(motorcycleId))
          ..orderBy([(t) => OrderingTerm(expression: t.mileage, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Add a new fuel log.
  Future<int> addFuelLog(FuelLogsCompanion companion) {
    return _db.into(_db.fuelLogs).insert(companion);
  }

  /// Update a fuel log.
  Future<bool> updateFuelLog(FuelLog log) {
    return _db.update(_db.fuelLogs).replace(log);
  }

  /// Delete a fuel log.
  Future<int> deleteFuelLog(int id) {
    return (_db.delete(_db.fuelLogs)..where((t) => t.id.equals(id))).go();
  }

  // ==========================================
  // 4. Parts CRUD (Filtered by Motorcycle)
  // ==========================================

  /// Stream of parts for a specific motorcycle.
  Stream<List<Part>> watchParts(int motorcycleId) {
    return (_db.select(_db.parts)..where((t) => t.motorcycleId.equals(motorcycleId))).watch();
  }

  /// Add a new part.
  Future<int> addPart(PartsCompanion companion) {
    return _db.into(_db.parts).insert(companion);
  }

  /// Update part details (e.g., changing status to installed).
  Future<bool> updatePart(Part part) {
    return _db.update(_db.parts).replace(part);
  }

  /// Delete a part.
  Future<int> deletePart(int id) {
    return (_db.delete(_db.parts)..where((t) => t.id.equals(id))).go();
  }
}
