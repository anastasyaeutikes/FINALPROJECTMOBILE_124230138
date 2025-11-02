import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  bool _isExitHovered = false;
  bool _isExitPressed = false;
  bool _isLoginHovered = false;
  bool _isLoginPressed = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 🔹 Login ke tabel "users" lewat AuthService
      final result = await _authService.signIn(email, password);

      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', result['id'] ?? '');
        await prefs.setString('name', result['name'] ?? '');
        await prefs.setString('username', result['username'] ?? '');
        await prefs.setString('email', result['email'] ?? '');
        await prefs.setString('loginTime', DateTime.now().toIso8601String());

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, ${result['name']}!')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Invalid credentials')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/salon.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // 🔹 Tombol Exit
          Positioned(
            top: 40,
            right: 20,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isExitHovered = true),
              onExit: (_) => setState(() {
                _isExitHovered = false;
                _isExitPressed = false;
              }),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isExitPressed = true),
                onTapUp: (_) {
                  setState(() => _isExitPressed = false);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isExitPressed
                        ? Colors.brown.shade400
                        : _isExitHovered
                            ? Colors.brown.shade300.withOpacity(0.9)
                            : Colors.brown.shade200.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: _isExitHovered
                        ? [
                            BoxShadow(
                              color: Colors.brown.shade300.withOpacity(0.6),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  transform: Matrix4.identity()
                    ..scale(_isExitPressed
                        ? 0.9
                        : _isExitHovered
                            ? 1.1
                            : 1.0),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),
          ),

          // 🔹 Form Login
          Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8EFE8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Please login before reservation!",
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Login
                  MouseRegion(
                    onEnter: (_) => setState(() => _isLoginHovered = true),
                    onExit: (_) => setState(() {
                      _isLoginHovered = false;
                      _isLoginPressed = false;
                    }),
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => _isLoginPressed = true),
                      onTapUp: (_) {
                        setState(() => _isLoginPressed = false);
                        if (!_isLoading) _handleLogin();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        transform: Matrix4.identity()
                          ..scale(_isLoginPressed
                              ? 0.95
                              : _isLoginHovered
                                  ? 1.05
                                  : 1.0),
                        decoration: BoxDecoration(
                          color: _isLoginPressed
                              ? Colors.brown.shade400
                              : Colors.brown.shade300.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Link ke SignUp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have an account? ",
                          style: GoogleFonts.poppins(fontSize: 12)),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/signup'),
                        child: Text("Sign Up",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.brown,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
