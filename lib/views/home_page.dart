import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// ✅ Fungsi untuk mengecek login dan arahkan ke halaman sesuai status
  Future<void> _handleReservation(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Jika sudah login → langsung ke halaman treatment
      Navigator.pushNamed(context, '/treatment');
    } else {
      // Jika belum login → arahkan ke halaman login
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'lib/assets/salon.png',
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NavItem(title: 'Contact Us', route: '/contact'),
                      const SizedBox(width: 20),
                      NavItem(title: 'Home', route: '/'),
                      const SizedBox(width: 20),
                      NavItem(title: 'Treatment', route: '/treatment'),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 80,
                  left: 30,
                  child: IconButton(
                    onPressed: () {},
                    icon:
                        const Icon(Icons.search, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF8EFE8),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hair\nSalon\n“Hayyina”",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleReservation(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC88E63),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reservation now',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  final String route;

  const NavItem({super.key, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
