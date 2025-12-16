import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beautyapp/screens/auth/login_screen.dart'; // Sesuaikan import

void main() {
  testWidgets('LoginScreen displays required fields', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Verify that the username and password fields are present.
    expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    // Verify that the Login button is present.
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    // Verify that the Register link is present.
    expect(find.text('Belum punya akun? Daftar di sini'), findsOneWidget);
  });

  // Anda dapat menambahkan lebih banyak test di sini untuk Register, Home, dll.
}
