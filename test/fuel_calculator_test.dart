import 'package:flutter_test/flutter_test.dart';
import 'package:motorcycle_assistant/database/database.dart';
import 'package:motorcycle_assistant/services/fuel_calculator.dart';

void main() {
  // Helper to create a FuelLog
  FuelLog createLog({
    required int id,
    required int mileage,
    required double amount,
    required bool fullTank,
  }) {
    return FuelLog(
      id: id,
      motorcycleId: 1,
      date: DateTime.now(),
      mileage: mileage,
      amount: amount,
      fullTank: fullTank,
    );
  }

  group('FuelCalculator.calculateEconomy Tests', () {
    test('Should return null for a single log (no baseline)', () {
      final current = createLog(id: 1, mileage: 1000, amount: 5.0, fullTank: true);
      final history = [current];

      final economy = FuelCalculator.calculateEconomy(current, history);
      expect(economy, isNull);
    });

    test('Should return null if current log is a partial fill', () {
      final log1 = createLog(id: 1, mileage: 1000, amount: 5.0, fullTank: true);
      final log2 = createLog(id: 2, mileage: 1200, amount: 4.0, fullTank: false); // Partial
      final history = [log2, log1]; // Descending mileage

      final economy = FuelCalculator.calculateEconomy(log2, history);
      expect(economy, isNull);
    });

    test('Should calculate correctly for two consecutive full fills', () {
      final log1 = createLog(id: 1, mileage: 1000, amount: 5.0, fullTank: true); // Baseline
      final log2 = createLog(id: 2, mileage: 1300, amount: 6.0, fullTank: true); // Current
      final history = [log2, log1];

      final economy = FuelCalculator.calculateEconomy(log2, history);
      // Distance = 300, Fuel = 6
      expect(economy, equals(50.0)); // 300 / 6
    });

    test('Should calculate correctly with partial fills in between full fills', () {
      final log1 = createLog(id: 1, mileage: 1000, amount: 5.0, fullTank: true); // Baseline Full
      final log2 = createLog(id: 2, mileage: 1150, amount: 3.0, fullTank: false); // Partial
      final log3 = createLog(id: 3, mileage: 1300, amount: 5.0, fullTank: true); // Current Full
      final history = [log3, log2, log1];

      final economy = FuelCalculator.calculateEconomy(log3, history);
      // Distance = 300 (1300 - 1000)
      // Total Fuel since last full = 3.0 (at log2) + 5.0 (at log3) = 8.0
      expect(economy, equals(37.5)); // 300 / 8
    });

    test('Should return null if no previous full tank exists (even with multiple partials)', () {
      final log1 = createLog(id: 1, mileage: 1000, amount: 2.0, fullTank: false);
      final log2 = createLog(id: 2, mileage: 1100, amount: 3.0, fullTank: false);
      final log3 = createLog(id: 3, mileage: 1300, amount: 5.0, fullTank: true); // Current is full, but no base full
      final history = [log3, log2, log1];

      final economy = FuelCalculator.calculateEconomy(log3, history);
      expect(economy, isNull);
    });

    test('Should return null if mileage data is invalid (e.g., current mileage < previous)', () {
      final log1 = createLog(id: 1, mileage: 1000, amount: 5.0, fullTank: true);
      final log2 = createLog(id: 2, mileage: 900, amount: 6.0, fullTank: true); // Invalid mileage
      final history = [log2, log1];

      final economy = FuelCalculator.calculateEconomy(log2, history);
      expect(economy, isNull);
    });
  });

  group('Unit Conversion Tests', () {
    test('MPG to Km/L conversion', () {
      expect(FuelCalculator.mpgToKml(1.0), closeTo(0.425144, 0.0001));
      expect(FuelCalculator.mpgToKml(40.0), closeTo(17.00576, 0.0001));
    });

    test('Km/L to MPG conversion', () {
      expect(FuelCalculator.kmlToMpg(1.0), closeTo(2.352146, 0.0001));
      expect(FuelCalculator.kmlToMpg(17.0), closeTo(39.986, 0.01));
    });
  });
}
