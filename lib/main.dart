import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/supabase_client.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';
import 'views/signup_page.dart';
import 'views/category_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load();
    await SupabaseManager.init();
    runApp(const MyApp());
  } catch (e) {
    print('Initialization error: $e');
    runApp(const MaterialApp(
        home: Scaffold(body: Center(child: Text('Error initializing app')))));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Love Your Self',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF8EFE8),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/category': (context) => const CategoryPage(),
      },
    );
  }
}
