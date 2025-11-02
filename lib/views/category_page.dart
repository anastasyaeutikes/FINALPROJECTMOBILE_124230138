import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'hair_care_page.dart';
import 'skin_care_page.dart';
import 'body_care_page.dart';
import 'nail_care_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';
  late List<CategoryModel> categories;

  @override
  void initState() {
    super.initState();
    categories = CategoryService().getCategories();
  }

  void _navigateToCategory(String route) {
    switch (route) {
      case 'hair':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HairCarePage()),
        );
        break;
      case 'skin':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SkinCarePage()),
        );
        break;
      case 'body':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BodyCarePage()),
        );
        break;
      case 'nail':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NailCarePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories
        .where((cat) => cat.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9E9DD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // === SEARCH BAR ===
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() => query = value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search category...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // === CATEGORY GRID ===
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.8,
                  children: filteredCategories.map((category) {
                    return GestureDetector(
                      onTap: () => _navigateToCategory(category.route),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                category.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.title,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      // === NAVIGATION BAR ===
      bottomNavigationBar: Padding(
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
              _buildNavIcon(context, Icons.home, const HomePage()),
              _buildNavIcon(context, Icons.search, const CategoryPage()),
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
