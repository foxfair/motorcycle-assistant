import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DistanceUnit {
  miles,
  kilometers;

  String get label => this == DistanceUnit.miles ? 'mi' : 'km';
}

enum FuelUnit {
  gallons,
  liters;

  String get label => this == FuelUnit.gallons ? 'gal' : 'L';
}

enum EconomyUnit {
  mpg,
  kmPerL,
  lPer100km;

  String get label {
    switch (this) {
      case EconomyUnit.mpg:
        return 'MPG';
      case EconomyUnit.kmPerL:
        return 'km/L';
      case EconomyUnit.lPer100km:
        return 'L/100km';
    }
  }
}

class SettingsState {
  final DistanceUnit distanceUnit;
  final FuelUnit fuelUnit;
  final EconomyUnit economyUnit;

  SettingsState({
    required this.distanceUnit,
    required this.fuelUnit,
    required this.economyUnit,
  });

  SettingsState copyWith({
    DistanceUnit? distanceUnit,
    FuelUnit? fuelUnit,
    EconomyUnit? economyUnit,
  }) {
    return SettingsState(
      distanceUnit: distanceUnit ?? this.distanceUnit,
      fuelUnit: fuelUnit ?? this.fuelUnit,
      economyUnit: economyUnit ?? this.economyUnit,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return SettingsState(
      distanceUnit: DistanceUnit.values[_prefs.getInt('distanceUnit') ?? 0],
      fuelUnit: FuelUnit.values[_prefs.getInt('fuelUnit') ?? 0],
      economyUnit: EconomyUnit.values[_prefs.getInt('economyUnit') ?? 0],
    );
  }

  Future<void> setDistanceUnit(DistanceUnit unit) async {
    await _prefs.setInt('distanceUnit', unit.index);
    state = state.copyWith(distanceUnit: unit);
  }

  Future<void> setFuelUnit(FuelUnit unit) async {
    await _prefs.setInt('fuelUnit', unit.index);
    state = state.copyWith(fuelUnit: unit);
  }

  Future<void> setEconomyUnit(EconomyUnit unit) async {
    await _prefs.setInt('economyUnit', unit.index);
    state = state.copyWith(economyUnit: unit);
  }
}

/// Provider for SharedPreferences. Must be overridden in main.dart during app startup.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Provider for the application settings.
final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
