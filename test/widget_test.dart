import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairsalonhayyina/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hairsalonhayyina/services/supabase_client.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Setup SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});

    // Initialize Supabase
    await SupabaseManager.init();
  });

  group('App Widget Tests', () {
    testWidgets('Home page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test app bar
      expect(find.text('Hayyina Salon'), findsOneWidget);

      // Test bottom navigation items
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.spa), findsOneWidget);
      expect(find.byIcon(Icons.contact_mail), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('Navigation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test navigation to Treatment page
      await tester.tap(find.byIcon(Icons.spa));
      await tester.pumpAndSettle();
      expect(find.text('Treatment'), findsOneWidget);

      // Test navigation to Contact page
      await tester.tap(find.byIcon(Icons.contact_mail));
      await tester.pumpAndSettle();
      expect(find.text('Contact Us'), findsOneWidget);

      // Test navigation back to Home
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.text('Hayyina Salon'), findsOneWidget);
    });
  });
}
