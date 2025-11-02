import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // pastikan file ini sudah ada
import '../services/auth_service.dart'; // added import

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController =
      TextEditingController(text: '0821 2345 6789');
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService(); // added field

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      isLoggedIn = loggedIn;
      if (isLoggedIn) {
        // Ambil data yang disimpan saat login
        nameController.text = prefs.getString('name') ?? '';
        usernameController.text = prefs.getString('username') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      } else {
        // Kosongkan jika belum login
        nameController.clear();
        usernameController.clear();
        passwordController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E9DD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoggedIn
                ? _buildProfileContent()
                : _buildLoginPrompt(context),
          ),
        ),
      ),
    );
  }

  // Tampilan jika belum login
  Widget _buildLoginPrompt(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.person_outline, size: 72, color: Colors.brown),
        const SizedBox(height: 12),
        const Text(
          "You're not logged in.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Please log in for a better experience.",
          style: TextStyle(color: Colors.brown, fontSize: 14),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ).then((_) => _loadProfile()); // reload saat kembali
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            backgroundColor: const Color(0xFFC88E63),
          ),
          child: const Text(
            "Go to Login",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Tampilan jika sudah login: tampilkan data nama, username, password dan tombol logout
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xFFDAB79A),
            child: const Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildTextField("Name", nameController, readOnly: true),
          const SizedBox(height: 10),
          _buildTextField("Username", usernameController, readOnly: true),
          const SizedBox(height: 10),
          _buildTextField("Password", passwordController,
              obscureText: true, readOnly: true),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // logout: panggil supabase signOut jika tersedia, lalu hapus SharedPreferences dan kembali ke home
              try {
                await _authService
                    .signOut(); // safe to call even if not signed in
              } catch (_) {
                // ignore errors from signOut, tetap proceed to clear prefs
              }
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('name');
              await prefs.remove('username');
              await prefs.remove('password');

              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/', // route HomePage
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC88E63),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false, bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8EFE8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
