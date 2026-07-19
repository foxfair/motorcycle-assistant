import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:motorcycle_assistant/main.dart';
import 'package:motorcycle_assistant/providers.dart';
import 'package:motorcycle_assistant/database/database.dart';
import 'package:motorcycle_assistant/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motorcycle_assistant/services/settings_service.dart';

void main() {
  // Override for Linux to use the versioned sqlite3 library in tests
  open.overrideFor(OperatingSystem.linux, () {
    return DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0');
  });

  late AppDatabase database;

  setUp(() {
    database = AppDatabase.connect(NativeDatabase.memory());
    NotificationService.isTest = true;
  });

  testWidgets('Full Garage to Dashboard navigation smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame, overriding the database to be in-memory
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) {
            ref.onDispose(() => database.close());
            return database;
          }),
          sharedPreferencesProvider.overrideWithValue(prefs),
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
    await tester.enterText(find.bySemanticsLabel(RegExp('VIN')), 'JH4SD08123456');
    await tester.enterText(find.bySemanticsLabel(RegExp('Notes')), 'My overland travel companion');

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
    expect(find.text('Red Beast'), findsNWidgets(2)); // AppBar title + Vehicle Info card
    expect(find.text('2021 Honda Africa Twin'), findsOneWidget); // AppBar subtitle

    // Verify dashboard displays initial/empty stats
    expect(find.text('0 mi'), findsOneWidget); // Initial mileage
    expect(find.textContaining('No fuel logs recorded yet'), findsOneWidget);
    expect(find.textContaining('Never recorded'), findsAtLeastNWidgets(2)); // Default tasks status (Oil, Chain, etc.)

    // Verify Vehicle Information card is displayed
    expect(find.text('Vehicle Information'), findsOneWidget);
    expect(find.text('JH4SD08123456'), findsOneWidget);
    expect(find.text('My overland travel companion'), findsOneWidget);

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
    await tester.enterText(find.bySemanticsLabel(RegExp('Price')), '4.00');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify first fuel log is listed (no economy calculated yet)
    expect(find.text('3.00 gal'), findsOneWidget);
    expect(find.textContaining('Price: \$4.00/gal'), findsOneWidget);
    expect(find.textContaining('Odometer: 1000 mi'), findsOneWidget);
    expect(find.text('50.0 MPG'), findsNothing); // No economy yet

    // Tap FAB to add second Fuel Log (@ 1300 mi, 6 gallons, full tank)
    await tester.tap(find.byKey(const ValueKey('add_fuel_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel(RegExp('Odometer')), '1300');
    await tester.enterText(find.bySemanticsLabel(RegExp('Amount')), '6.0');
    await tester.enterText(find.bySemanticsLabel(RegExp('Price')), '5.00');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Wait for database streams to emit and update
    await tester.idle();
    await tester.pump();

    // Verify second fuel log is listed with calculated MPG (300 miles / 6 gallons = 50.0 MPG)
    expect(find.text('6.00 gal'), findsOneWidget);
    expect(find.textContaining('Price: \$5.00/gal'), findsOneWidget);
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
    expect(find.text('\$42.00'), findsOneWidget);
    expect(find.text('\$0.093/mi'), findsOneWidget);

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
    // 6.7. Trigger notification: Log Fuel @ 4600 mi to make Oil Change 'dueSoon'
    // ============================================================================
    // Tap on Logs tab
    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    // Switch to Fuel Logs sub-tab
    await tester.tap(find.text('Fuel Logs'));
    await tester.pumpAndSettle();

    // Tap FAB to add Fuel Log (@ 4700 mi, 5 gallons)
    await tester.tap(find.byKey(const ValueKey('add_fuel_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel(RegExp('Odometer')), '4700');
    await tester.enterText(find.bySemanticsLabel(RegExp('Amount')), '5.0');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Wait for database updates to propagate and trigger reminders update
    await tester.idle();
    await tester.pump();

    // Go back to Dashboard to verify Odometer is 4700 mi and Oil Change is 'dueSoon'
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    await tester.idle();
    await tester.pump();

    expect(find.text('4700 mi'), findsOneWidget);
    expect(find.textContaining('Due in 300 mi'), findsOneWidget); // Oil Change should be due soon

    // ============================================================================
    // 6.8. Test App Settings and Unit Conversions
    // ============================================================================
    // Tap Settings button in AppBar
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify Settings dialog is shown
    expect(find.text('App Settings'), findsOneWidget);

    // Change Distance Unit to Kilometers (second option)
    await tester.tap(find.text('Miles (mi)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kilometers (km)').last);
    await tester.pumpAndSettle();

    // Change Fuel Unit to Liters (second option)
    await tester.tap(find.text('Gallons (gal)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Liters (L)').last);
    await tester.pumpAndSettle();

    // Change Economy Unit to km/L (second option)
    await tester.tap(find.text('Miles per Gallon (MPG)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kilometers per Liter (km/L)').last);
    await tester.pumpAndSettle();

    // Tap Close button
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Verify Dashboard displays converted units:
    // Odometer: 4700 mi * 1.60934 = 7564 km (rounded)
    expect(find.text('7564 km'), findsOneWidget);

    // Average: 336.36 MPG * 0.425144 = 143.0 km/L
    // Latest: 680.0 MPG * 0.425144 = 289.1 km/L
    expect(find.text('143.0 km/L'), findsOneWidget);
    expect(find.text('289.1 km/L'), findsOneWidget);

    // Cost per Mile: $0.01387/mi -> Cost per Km: $0.01387 / 1.60934 = $0.009/km (approx)
    expect(find.text('\$0.009/km'), findsOneWidget);
    expect(find.text('Cost per Km'), findsOneWidget);

    // Verify Maintenance Reminder shows converted due status:
    // "Due in 300 mi" * 1.60934 = 483 km (rounded)
    expect(find.textContaining('Due in 483 km'), findsOneWidget);

    // ============================================================================
    // 6.9. Test Logging with Metric Inputs
    // ============================================================================
    // Tap on Logs tab
    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    // Switch to Maintenance sub-tab
    await tester.tap(find.text('Maintenance'));
    await tester.pumpAndSettle();

    // Verify logs show converted displays:
    // Odometer in Maintenance log: 1000 mi * 1.60934 = 1609 km
    expect(find.textContaining('Mileage: 1609 km'), findsOneWidget);

    // Switch to Fuel Logs sub-tab
    await tester.tap(find.text('Fuel Logs'));
    await tester.pumpAndSettle();

    // Verify fuel logs show converted:
    // Log 1: 3.00 gal * 3.78541 = 11.36 L
    expect(find.text('11.36 L'), findsOneWidget);
    // Price: $4.00/gal -> $4.00 / 3.78541 = $1.06/L
    expect(find.textContaining('Price: \$1.06/L'), findsOneWidget);

    // Tap FAB to add new Fuel Log in Metric:
    // Current Odometer is 4700 mi (which is 7564 km). We log next fill at 7800 km.
    // Amount: 15.0 L (which is 3.962 gal)
    // Price: $1.20/L (which is $4.542/gal)
    await tester.tap(find.byKey(const ValueKey('add_fuel_button')));
    await tester.pumpAndSettle();

    // Verify labels in dialog are updated:
    expect(find.text('Odometer (km) *'), findsOneWidget);
    expect(find.text('Amount (L) *'), findsOneWidget);
    expect(find.text('Price per L (\$, optional)'), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel(RegExp('Odometer')), '7800');
    await tester.enterText(find.bySemanticsLabel(RegExp('Amount')), '15.0');
    await tester.enterText(find.bySemanticsLabel(RegExp('Price')), '1.20');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.idle();
    await tester.pump();

    // Verify the new log is listed in metric:
    expect(find.text('15.00 L'), findsOneWidget);
    expect(find.textContaining('Price: \$1.20/L'), findsOneWidget);
    expect(find.textContaining('Odometer: 7800 km'), findsOneWidget);
    expect(find.textContaining('Total: \$18.00'), findsOneWidget);

    // Go back to Dashboard
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    await tester.idle();
    await tester.pump();

    // Verify Odometer is 7800 km (max of logs)
    expect(find.text('7800 km'), findsOneWidget);

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
