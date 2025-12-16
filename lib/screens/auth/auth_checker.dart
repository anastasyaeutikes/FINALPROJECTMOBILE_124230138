// lib/screens/auth/auth_checker.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import '../../database/database_helper.dart';
import '../../services/user_service.dart';
import '../main_screen.dart';
import 'login_screen.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final isLoggedIn = prefs.getBool(kIsLoggedInKey) ?? false;
      final userId = prefs.getInt(kLoggedInUserIdKey);

      // Jika tidak ada user ID → anggap belum login
      if (!isLoggedIn || userId == null) {
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
        return;
      }

      // Cek keberadaan user di database
      final db = await DatabaseHelper.instance.database;
      final userService = UserService(db);

      final user = await userService.getLoggedInUser(userId);

      if (user != null) {
        // User valid, tetap login
        setState(() {
          _isLoggedIn = true;
          _isLoading = false;
        });
      } else {
        // User dihapus dari DB → logout otomatis
        prefs.clear();
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Error → anggap belum login
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.face_retouching_natural, size: 80, color: Colors.pink),
              SizedBox(height: 20),
              Text(
                'Beauty App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(color: Colors.pink),
            ],
          ),
        ),
      );
    }

    return _isLoggedIn ? const MainScreen() : const LoginScreen();
  }
}
