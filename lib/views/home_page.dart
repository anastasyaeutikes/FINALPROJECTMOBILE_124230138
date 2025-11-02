import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// ✅ Navigasi ke CategoryPage
  void _handleMore(BuildContext context) {
    Navigator.pushNamed(context, '/category');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Gambar utama (header)
            Image.asset(
              'lib/assets/images/LoveYourSelf.jpg',
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),

            // ✅ Konten utama
            Container(
              width: double.infinity,
              color: const Color(0xFFF8EFE8),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Love\nYour\nSelf",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleMore(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC88E63),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'More',
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
