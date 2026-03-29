# Pocket Plan 
> Master Your Money, Whatever It Looks Like

A fully functional mobile application built with Flutter, applying Clean Architecture principles and a Firebase backend for data management and authentication.

## Features
- Safe-to-Spend daily calculator
- Multi-source income logging  
- Expense tracking and categorization
- Lean Period early warning alerts
- Emergency buffer savings

## Pre-requisites
To build and run this application, ensure you have the following installed on your system:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version ^3.10.0 or higher recommended)
- Android Studio or Xcode (for emulators and build tools)
- Visual Studio Code (or your preferred IDE)
- Firebase project with Authentication and Firestore enabled

## Getting Started

Follow these steps to set up the project locally on your machine:

1. **Clone the repository:**
   ```bash
   git clone # https://github.com/hamse-ai/pocketPlan.git or git@github.com:hamse-ai/pocketPlan.git
   cd pocket_plan
   ```

2. **Fetch dependencies:**
   The project depends on several packages (e.g., `flutter_bloc`, `get_it`, `equatable`, etc.). Run the following command to download all necessary dependencies:
   ```bash
   flutter pub get
   ```

3. **Run the App:**
   Ensure you have a physical device connected or an emulator running. Build and run the app with:
   ```bash
   flutter run
   ```

## Project Architecture

This project strictly adheres to **Clean Architecture** patterns. 

The application code inside `lib/` is organized as follows:
- **core/**: Contains application-wide utilities, error handling, networking code, and generic usecases.
- **features/**: Contains the main features of the application,separated by domain (e.g., `auth`, `income`, `budget`, `profile`, `settings`).
  - Each feature is further divided into three layers:
    - **data/**: Deals with external data (DataSources, Repositories implementations, Models).
    - **domain/**: Contains the core business logic (Entities, Repositories interfaces, UseCases).
    - **presentation/**: Handles the UI (Pages, Widgets) and State Management (BLoC).

## State Management

This application uses the **BLoC (Business Logic Component)** pattern for state management. Ensure you separate your logic into state and events, and keep UI components stateless where appropriate.

## Testing

To run the widget and unit tests:
```bash
flutter test
```
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is for academic purposes — African Leadership University, 2025.
