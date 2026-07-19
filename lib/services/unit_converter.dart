import 'settings_service.dart';

class UnitConverter {
  // --- Distance ---
  static double convertDistance(double miles, DistanceUnit targetUnit) {
    if (targetUnit == DistanceUnit.kilometers) {
      return miles * 1.60934;
    }
    return miles;
  }

  static double convertDistanceBack(double value, DistanceUnit currentUnit) {
    if (currentUnit == DistanceUnit.kilometers) {
      return value / 1.60934;
    }
    return value;
  }

  // --- Volume ---
  static double convertVolume(double gallons, FuelUnit targetUnit) {
    if (targetUnit == FuelUnit.liters) {
      return gallons * 3.78541;
    }
    return gallons;
  }

  static double convertVolumeBack(double value, FuelUnit currentUnit) {
    if (currentUnit == FuelUnit.liters) {
      return value / 3.78541;
    }
    return value;
  }

  // --- Price per Unit ---
  // Stored in $/gal. If target is Liters: Price/L = (Price/gal) / 3.78541
  static double convertPrice(double pricePerGal, FuelUnit targetUnit) {
    if (targetUnit == FuelUnit.liters) {
      return pricePerGal / 3.78541;
    }
    return pricePerGal;
  }

  // Entered in $/L. To save in $/gal: Price/gal = (Price/L) * 3.78541
  static double convertPriceBack(double value, FuelUnit currentUnit) {
    if (currentUnit == FuelUnit.liters) {
      return value * 3.78541;
    }
    return value;
  }

  // --- Fuel Economy ---
  // Base is MPG (Miles / Gallons)
  static double convertEconomy(double mpg, EconomyUnit targetUnit) {
    if (mpg <= 0) return 0.0;
    switch (targetUnit) {
      case EconomyUnit.mpg:
        return mpg;
      case EconomyUnit.kmPerL:
        // Km/L = MPG * 0.425144
        return mpg * 0.425144;
      case EconomyUnit.lPer100km:
        // L/100km = 235.215 / MPG
        return 235.215 / mpg;
    }
  }

  // --- Cost per Unit Distance ---
  // Stored in $/mi. If target is Kilometers: Cost/km = (Cost/mi) / 1.60934
  static double convertCostPerDistance(double costPerMile, DistanceUnit targetUnit) {
    if (targetUnit == DistanceUnit.kilometers) {
      return costPerMile / 1.60934;
    }
    return costPerMile;
  }
}
