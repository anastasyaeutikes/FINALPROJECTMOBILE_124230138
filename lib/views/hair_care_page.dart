import 'package:flutter/material.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'profile_page.dart';

class HairCarePage extends StatelessWidget {
  const HairCarePage({super.key});

  final Color backgroundColor = const Color(0xFFF3CFA0);
  final Color cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final List<String> topics = [
      'Hair types (dry, oily, damaged, dandruff-prone)',
      'Tips and step-by-step hair care routines',
      "Do's & Don'ts",
      'Recommended products (shampoo, conditioner, hair mask, serum)',
      'Articles',
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // HEADER IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            child: Image.asset(
              'lib/assets/images/haircare.jpg',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // CONTENT CARDS
          Expanded(
            child: Container(
              color: backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ListView.separated(
                itemCount: topics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      topics[index],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // NAVIGATION BAR
      bottomNavigationBar: _buildNavBar(context),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, left: 24, right: 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavIcon(context, Icons.search, const CategoryPage()),
            _buildNavIcon(context, Icons.home, const HomePage()),
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xFFC88E63),
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, IconData icon, Widget page) {
    return IconButton(
      icon: Icon(icon, color: Colors.black, size: 24),
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
