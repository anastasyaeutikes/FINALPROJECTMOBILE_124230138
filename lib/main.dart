import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/notification_service.dart';
import 'screens/auth/auth_checker.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize Notification Service
  try {
    await NotificationService().initialize();
    debugPrint('✅ Notification Service initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Failed to initialize Notification Service: $e');
    // App will continue to work without notifications
  }

  runApp(const BeautyApp());
}

class BeautyApp extends StatelessWidget {
  const BeautyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty Routine App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary Colors
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          primary: Colors.pink,
          secondary: Colors.pinkAccent,
          brightness: Brightness.light,
        ),

        // Scaffold Background
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),

        // AppBar Theme - Matching HomePage style
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Card Theme
        cardTheme: CardThemeData(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadowColor: Colors.grey.shade300,
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Input Decoration Theme - Matching HomePage search bar
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.pink, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.pink,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          elevation: 4,
        ),

        // Progress Indicator Theme
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.pink,
        ),

        // SnackBar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.grey[800],
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 6,
        ),

        // Divider Theme
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade300,
          thickness: 1,
          space: 1,
        ),

        // Icon Theme
        iconTheme: IconThemeData(color: Colors.grey.shade700, size: 24),

        // Text Theme - Default text styles
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
          bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
        ),

        // List Tile Theme
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minLeadingWidth: 40,
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      home: const AuthChecker(),
    );
  }
}
