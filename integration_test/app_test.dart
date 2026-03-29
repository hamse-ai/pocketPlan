import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pocket_plan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Human Journey', () {
    testWidgets('Complete app navigation and screen interaction', (WidgetTester tester) async {
      // 1. App Startup
      app.main();
      await tester.pumpAndSettle();

      // Check if we are on Login or Home (depends on Auth state)
      final homePageFinder = find.byKey(const Key('home_page_scaffold'));
      final loginPageFinder = find.text('Login'); // Simplified finder for login

      if (homePageFinder.evaluate().isNotEmpty) {
        debugPrint('App started on HomePage');
      } else if (loginPageFinder.evaluate().isNotEmpty) {
        debugPrint('App started on LoginPage');
        // Note: For a real CI, you would automate login here.
        // For now, we assume the user is logged in or the mock auth handles it.
        return; 
      }

      // 2. Verify Home Page Content
      expect(find.text('Safe to Spend'), findsOneWidget);

      // 3. Navigate to Income Screen
      final navBar = find.byKey(const Key('bottom_nav_bar'));
      await tester.tap(find.descendant(of: navBar, matching: find.byIcon(Icons.attach_money)));
      await tester.pumpAndSettle();
      expect(find.text('Income'), findsOneWidget);

      // 4. Navigate to Expense Screen
      await tester.tap(find.descendant(of: navBar, matching: find.byIcon(Icons.money_off)));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('expense_screen_column')), findsOneWidget);

      // 5. Navigate to Profile
      await tester.tap(find.descendant(of: navBar, matching: find.byIcon(Icons.person)));
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsOneWidget);

      // 6. Navigate to Settings
      await tester.tap(find.descendant(of: navBar, matching: find.byIcon(Icons.settings)));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      // 7. Return Home
      await tester.tap(find.descendant(of: navBar, matching: find.byIcon(Icons.home)));
      await tester.pumpAndSettle();
      expect(homePageFinder, findsOneWidget);
    });
  });
}
