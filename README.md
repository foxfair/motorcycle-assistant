# Motorcycle Assistant

A mobile application built with Flutter to help riders manage their garage, track vehicle health, monitor fuel efficiency, and keep stock of parts/upgrades. Designed specifically for motorcyclists who own and maintain multiple bikes.

---

## 🚀 Key Features

*   🏍️ **Multi-Bike Garage:** Manage a collection of motorcycles. Track make, model, year, VIN, and custom notes, with easy switching between active bikes.
*   ⛽ **Fuel & MPG Tracker:** Log refuel details (gallons, price, full/partial tank). Automatically calculates:
    *   Average & Latest Fuel Economy (MPG).
    *   Total Fuel Spend.
    *   Cost per Mile.
*   🛠️ **Maintenance Reminders:** Record maintenance events (date, mileage, notes). Reminders dynamically calculate task status (`Clean`, `Due soon`, `Overdue`) based on mileage or time intervals (e.g. Oil change every 4,000 mi or 6 months).
*   ⚙️ **Parts & Upgrades Inventory:** Track aftermarket upgrades through their lifecycle (`In-progress` ➡️ `Ordered` ➡️ `Delivered` ➡️ `Installed`). Automatically logs a corresponding maintenance event when a part is installed.
*   🔔 **Local Notifications:** Alerts are triggered when a maintenance reminder transitions to `Due soon` or `Overdue`.

---

## 🛠️ Technical Stack

*   **Framework:** Flutter (Dart)
*   **Database:** Drift (SQLite) — for local, relational data persistence.
*   **State Management:** Riverpod — for reactive UI updates and clean architecture.
*   **Notifications:** `flutter_local_notifications` & `timezone` — for UTC-safe reminder alerts.

---

## 🗺️ Project Roadmap

### 📦 Phase 1: Foundation & Business Logic (Completed)
*   [x] Configure Drift database and multi-bike relational schema.
*   [x] Implement repository layer for CRUD operations.
*   [x] Implement business logic for MPG calculations and maintenance intervals.
*   [x] Write robust unit tests validating calculations.

### 🎨 Phase 2: User Interface MVP (Completed)
*   [x] **Garage Screen:** Add, view, and delete bikes.
*   [x] **Dashboard Tab:** Displays active odometer, fuel economy, spend stats, and urgent reminders.
*   [x] **Logs Tab:** Nested views showing historical Maintenance and Fuel logs (with individual fill efficiency).
*   [x] **Parts Tab:** Tracks aftermarket modifications with auto-maintenance logging upon installation.

### 🔔 Phase 3: Reminders & Polish (In Progress)
*   [x] Integrate local notifications triggered on reminder status shifts.
*   [x] Display advanced metrics (Cost per Mile, Total Spend) and active bike details (VIN/Notes).
*   [ ] Add settings to customize units (Miles vs. Kilometers, Gallons vs. Liters).
*   [ ] Implement basic data visualization (MPG trend charts over time).

### 🚀 Future Phases (Planned)
*   [ ] Cloud synchronization and database backup.
*   [ ] iOS build configuration and verification.

---

## 💻 Getting Started

### Prerequisites
*   Flutter SDK installed (tested with Flutter 3.x).
*   Android Studio / Android SDK for emulator or device testing.

### Running the App
To run the app on a connected emulator or device:
```bash
flutter run
```

### Running Tests
To run the unit and integration widget tests:
```bash
flutter test
```
*Note: If running tests on a headless Linux environment, the tests will automatically use a mocked notification service to bypass native plugin requirements.*
