import '../database/database.dart';

class FuelCalculator {
  /// Calculates the fuel economy (e.g., MPG or Km/L) for a given [current] log.
  ///
  /// [history] must be the list of all fuel logs for the motorcycle,
  /// sorted by mileage in descending order (newest first).
  ///
  /// Returns `null` if:
  /// * The [current] log is not a full tank (cannot calculate economy on partial fills).
  /// * There is no previous "full tank" log in the history to use as a baseline.
  /// * The distance calculated is zero or negative (invalid data).
  static double? calculateEconomy(FuelLog current, List<FuelLog> history) {
    if (!current.fullTank) {
      return null; // Cannot calculate economy for a partial fill
    }

    // Find the index of the current log in the history
    final currentIndex = history.indexWhere((log) => log.id == current.id);
    if (currentIndex == -1) return null;

    // Find the next oldest full tank log (higher index in descending history)
    int previousFullIndex = -1;
    for (int i = currentIndex + 1; i < history.length; i++) {
      if (history[i].fullTank) {
        previousFullIndex = i;
        break;
      }
    }

    if (previousFullIndex == -1) {
      return null; // No previous baseline full tank found
    }

    final previousFullLog = history[previousFullIndex];
    final distance = current.mileage - previousFullLog.mileage;
    if (distance <= 0) return null;

    // Sum fuel amounts from the current log back to (but not including) the previous full log
    double totalFuel = 0;
    for (int i = currentIndex; i < previousFullIndex; i++) {
      totalFuel += history[i].amount;
    }

    if (totalFuel <= 0) return null;

    return distance / totalFuel;
  }

  /// Helper to convert MPG to Km/L if needed for display.
  static double mpgToKml(double mpg) => mpg * 0.425144;

  /// Helper to convert Km/L to MPG if needed for display.
  static double kmlToMpg(double kml) => kml * 2.352146;
}
