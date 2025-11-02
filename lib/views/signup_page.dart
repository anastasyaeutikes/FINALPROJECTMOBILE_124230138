import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Animasi tombol exit dan sign up
  bool _isExitHovered = false;
  bool _isExitPressed = false;
  bool _isSignUpHovered = false;
  bool _isSignUpPressed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_isLoading) return;

    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validation
    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signUp(name, username, email, password);

      if (!mounted) return;

      if (result['success']) {
        // Store user data locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('name', name);
        await prefs.setString('username', username);
        await prefs.setString('email', email);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Signup failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
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
          // ✅ Background image
          Image.asset(
            'lib/assets/salon.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // ✅ Tombol Exit (pojok kanan atas)
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
                onTapCancel: () => setState(() => _isExitPressed = false),
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
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),

          // ✅ Kontainer form sign up
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Create an account to continue",
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    const SizedBox(height: 20),

                    // ✅ Name field (disamakan dengan kolom lain)
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Username field
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email field
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

                    // Password field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ Tombol Sign Up dengan animasi hover & klik
                    MouseRegion(
                      onEnter: (_) => setState(() => _isSignUpHovered = true),
                      onExit: (_) => setState(() {
                        _isSignUpHovered = false;
                        _isSignUpPressed = false;
                      }),
                      child: GestureDetector(
                        onTapDown: (_) =>
                            setState(() => _isSignUpPressed = true),
                        onTapUp: (_) {
                          setState(() => _isSignUpPressed = false);
                          if (!_isLoading) _signUp();
                        },
                        onTapCancel: () =>
                            setState(() => _isSignUpPressed = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          transform: Matrix4.identity()
                            ..scale(_isSignUpPressed
                                ? 0.95
                                : _isSignUpHovered
                                    ? 1.05
                                    : 1.0),
                          decoration: BoxDecoration(
                            color: _isSignUpPressed
                                ? Colors.brown.shade400
                                : _isSignUpHovered
                                    ? Colors.brown.shade300
                                    : Colors.brown.shade300.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _isSignUpHovered
                                ? [
                                    BoxShadow(
                                      color: Colors.brown.shade300
                                          .withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Redirect ke login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.brown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
