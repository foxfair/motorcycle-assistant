import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return AlertDialog(
      title: const Text('App Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Distance Unit
          DropdownButtonFormField<DistanceUnit>(
            value: settings.distanceUnit,
            decoration: const InputDecoration(labelText: 'Distance Unit'),
            items: DistanceUnit.values.map((unit) {
              final label = unit == DistanceUnit.miles ? 'Miles (mi)' : 'Kilometers (km)';
              return DropdownMenuItem(value: unit, child: Text(label));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                settingsNotifier.setDistanceUnit(val);
              }
            },
          ),
          const SizedBox(height: 12),

          // 2. Fuel Unit
          DropdownButtonFormField<FuelUnit>(
            value: settings.fuelUnit,
            decoration: const InputDecoration(labelText: 'Fuel Volume Unit'),
            items: FuelUnit.values.map((unit) {
              final label = unit == FuelUnit.gallons ? 'Gallons (gal)' : 'Liters (L)';
              return DropdownMenuItem(value: unit, child: Text(label));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                settingsNotifier.setFuelUnit(val);
              }
            },
          ),
          const SizedBox(height: 12),

          // 3. Economy Unit
          DropdownButtonFormField<EconomyUnit>(
            value: settings.economyUnit,
            decoration: const InputDecoration(labelText: 'Fuel Economy Unit'),
            items: EconomyUnit.values.map((unit) {
              String label;
              switch (unit) {
                case EconomyUnit.mpg:
                  label = 'Miles per Gallon (MPG)';
                  break;
                case EconomyUnit.kmPerL:
                  label = 'Kilometers per Liter (km/L)';
                  break;
                case EconomyUnit.lPer100km:
                  label = 'Liters per 100 Km (L/100km)';
                  break;
              }
              return DropdownMenuItem(value: unit, child: Text(label));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                settingsNotifier.setEconomyUnit(val);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
