import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairsalonhayyina/main.dart';

void main() {
  setUpAll(() async {
    // Initialize services needed for tests
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Home page displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Basic UI elements
    expect(find.text('Hayyina Salon'), findsOneWidget);
  });
}
