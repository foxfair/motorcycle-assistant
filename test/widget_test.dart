import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:motorcycle_assistant/main.dart';
import 'package:motorcycle_assistant/providers.dart';
import 'package:motorcycle_assistant/database/database.dart';

void main() {
  // Override for Linux to use the versioned sqlite3 library in tests
  open.overrideFor(OperatingSystem.linux, () {
    return DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0');
  });

  late AppDatabase database;

  setUp(() {
    database = AppDatabase.connect(NativeDatabase.memory());
  });

  testWidgets('Full Garage to Dashboard navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame, overriding the database to be in-memory
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) {
            ref.onDispose(() => database.close());
            return database;
          }),
        ],
        child: const MyApp(),
      ),
    );

    // Pump frames until the CircularProgressIndicator disappears (data is loaded)
    int limit = 0;
    while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty && limit < 20) {
      await tester.pump(const Duration(milliseconds: 100));
      limit++;
    }

    // 1. Verify we start on the Garage Screen (Empty State)
    expect(find.text('My Garage'), findsOneWidget);
    expect(find.textContaining('Your garage is empty'), findsOneWidget);

    // 2. Tap '+' to add a bike
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Wait for dialog animation to finish

    // Verify dialog is shown
    expect(find.text('Add Motorcycle'), findsOneWidget);

    // 3. Fill in the form
    await tester.enterText(find.bySemanticsLabel(RegExp('Nickname')), 'Red Beast');
    await tester.enterText(find.bySemanticsLabel(RegExp('Make')), 'Honda');
    await tester.enterText(find.bySemanticsLabel(RegExp('Model')), 'Africa Twin');
    await tester.enterText(find.bySemanticsLabel(RegExp('Year')), '2021');

    // Tap 'Add' button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle(); // Wait for dialog to close and list to refresh

    // 4. Verify the bike is now listed in the Garage
    expect(find.text('Red Beast'), findsOneWidget);
    expect(find.text('2021 Honda Africa Twin'), findsOneWidget);

    // 5. Tap on the bike to select it
    await tester.tap(find.text('Red Beast'));
    await tester.pumpAndSettle(); // Wait for screen transition

    // Wait for Dashboard to finish loading all data (Odometer, Fuel, Reminders)
    int dashboardLimit = 0;
    while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty && dashboardLimit < 20) {
      await tester.pump(const Duration(milliseconds: 100));
      dashboardLimit++;
    }

    // 6. Verify we are on the Home Screen Dashboard
    expect(find.text('Red Beast'), findsOneWidget); // AppBar title
    expect(find.text('2021 Honda Africa Twin'), findsOneWidget); // AppBar subtitle

    // Verify dashboard displays initial/empty stats
    expect(find.text('0 mi'), findsOneWidget); // Initial mileage
    expect(find.textContaining('No fuel logs recorded yet'), findsOneWidget);
    expect(find.textContaining('Never recorded'), findsAtLeastNWidgets(2)); // Default tasks status (Oil, Chain, etc.)

    // ============================================================================
    // 6.5. Test Logs Tab (Maintenance & Fuel Logging)
    // ============================================================================

    // Tap on the Logs tab in bottom navigation
    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    // Verify we start on Maintenance Logs sub-tab (Empty State)
    expect(find.text('No maintenance logs recorded.'), findsOneWidget);

    // Tap FAB to add Maintenance Log
    await tester.tap(find.byKey(const ValueKey('add_maint_button')));
    await tester.pumpAndSettle();

    // Fill form: Mileage 1000, Task defaults to 'Oil Change'
    await tester.enterText(find.bySemanticsLabel(RegExp('Odometer')), '1000');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify maintenance log is listed
    expect(find.text('Oil Change'), findsOneWidget);
    expect(find.textContaining('Mileage: 1000 mi'), findsOneWidget);

    // Switch to Fuel Logs sub-tab
    await tester.tap(find.text('Fuel Logs'));
    await tester.pumpAndSettle();

    // Verify empty state
    expect(find.text('No fuel logs recorded.'), findsOneWidget);

    // Tap FAB to add Fuel Log (baseline @ 1000 mi, 3 gallons)
    await tester.tap(find.byKey(const ValueKey('add_fuel_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel(RegExp('Odometer')), '1000');
    await tester.enterText(find.bySemanticsLabel(RegExp('Amount')), '3.0');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify first fuel log is listed (no economy calculated yet)
    expect(find.text('3.00 gal'), findsOneWidget);
    expect(find.textContaining('Odometer: 1000 mi'), findsOneWidget);
    expect(find.text('50.0 MPG'), findsNothing); // No economy yet

    // Tap FAB to add second Fuel Log (@ 1300 mi, 6 gallons, full tank)
    await tester.tap(find.byKey(const ValueKey('add_fuel_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel(RegExp('Odometer')), '1300');
    await tester.enterText(find.bySemanticsLabel(RegExp('Amount')), '6.0');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Wait for database streams to emit and update
    await tester.idle();
    await tester.pump();

    // Verify second fuel log is listed with calculated MPG (300 miles / 6 gallons = 50.0 MPG)
    expect(find.text('6.00 gal'), findsOneWidget);
    expect(find.textContaining('Odometer: 1300 mi'), findsOneWidget);
    expect(find.text('50.0 MPG'), findsOneWidget);

    // Go back to Dashboard tab
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    await tester.idle();
    await tester.pump();

    // Verify Odometer updated to 1300 mi (max of logs)
    expect(find.text('1300 mi'), findsOneWidget);

    // Verify Fuel stats updated to 50.0 MPG (Average and Latest are both 50.0)
    expect(find.text('50.0 MPG'), findsNWidgets(2));

    // Verify Oil Change reminder is updated to "Due at 5000 mi" (1000 last done + 4000 interval)
    expect(find.textContaining('Due at 5000 mi'), findsOneWidget);
    expect(find.textContaining('Never recorded'), findsNWidgets(3)); // 3 other tasks still untouched

    // ============================================================================
    // 6.6. Test Parts Tab (Add Part with Auto-Maint Log)
    // ============================================================================
    // Tap on the Parts tab in bottom navigation
    await tester.tap(find.text('Parts'));
    await tester.pumpAndSettle();

    // Verify empty state
    expect(find.text('No parts tracked yet. Add your first upgrade!'), findsOneWidget);

    // Tap FAB to add Part
    await tester.tap(find.byKey(const ValueKey('add_part_button')));
    await tester.pumpAndSettle();

    // Fill form: Name "Yoshimura Exhaust", Status "Installed", Mileage 1400
    await tester.enterText(find.bySemanticsLabel(RegExp('Part Name')), 'Yoshimura Exhaust');
    
    // Select 'Installed' from dropdown
    await tester.tap(find.text('In-progress')); // Open dropdown (default value)
    await tester.pumpAndSettle();
    await tester.tap(find.text('Installed').last); // Select 'Installed' from dropdown list
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel(RegExp('Installation Odometer')), '1400');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify part is listed as Installed @ 1400 mi
    expect(find.text('Yoshimura Exhaust'), findsOneWidget);
    expect(find.text('Installed'), findsOneWidget);
    expect(find.textContaining('Installed @ 1400 mi'), findsOneWidget);

    // Navigate to Logs tab to verify the auto-created maintenance entry
    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();
    
    // LogsTab preserves its state (IndexedStack), so it will be on 'Fuel Logs' tab from earlier.
    // Switch to 'Maintenance' sub-tab to verify.
    await tester.tap(find.text('Maintenance'));
    await tester.pumpAndSettle();
    await tester.idle();
    await tester.pump();

    // Verify the auto-logged maintenance entry is present
    expect(find.text('Installed: Yoshimura Exhaust'), findsOneWidget);
    expect(find.textContaining('Mileage: 1400 mi'), findsOneWidget);

    // Go back to Dashboard tab
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    await tester.idle();
    await tester.pump();

    // Verify Odometer updated to 1400 mi (max of logs, updated from the auto-logged maintenance log @ 1400 mi)
    expect(find.text('1400 mi'), findsOneWidget);

    // ============================================================================
    // 7. Revert state: Tap 'Switch Bike' to go back to Garage
    // ============================================================================
    await tester.tap(find.byIcon(Icons.swap_horizontal_circle_outlined));
    await tester.pumpAndSettle();

    // Verify we are back in the Garage
    expect(find.text('My Garage'), findsOneWidget);
    expect(find.text('Red Beast'), findsOneWidget);

    // Force disposal of MyApp and ProviderScope to trigger database close
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle(); // Flush any final cleanup timers
  });
}
