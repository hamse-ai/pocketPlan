import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  // Ensure Flutter bindings are initialized before calling Firebase or GetIt
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();

  runApp(const PocketPlanApp());
}

class PocketPlanApp extends StatelessWidget {
  const PocketPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // TODO: Register your Feature BLoCs here
        // BlocProvider(create: (_) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Pocket Plan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // TODO: Implement custom core Theme in core/theme
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const InitialScreen(), // Placeholder for initial routing logic
      ),
    );
  }
}

// ------------------------------------------------------------------------
// Placeholder Screen to ensure the app compiles out of the box
// ------------------------------------------------------------------------

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket Plan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text(
          'Welcome to Pocket Plan\nBuilding Financial Resilience',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
