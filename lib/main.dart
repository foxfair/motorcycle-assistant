import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'ui/garage_screen.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motorcycle Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Support system dark mode
      home: const MainRouter(),
    );
  }
}

class MainRouter extends ConsumerWidget {
  const MainRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBike = ref.watch(selectedMotorcycleProvider);

    if (selectedBike == null) {
      return const GarageScreen();
    } else {
      return HomeScreen(motorcycle: selectedBike);
    }
  }
}
