import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import 'product_recommendation_page.dart';
import 'makeup_tips_page.dart';
import 'makeup_tools_page.dart';
import '../schedule/schedule_page.dart';

class HomePage extends StatefulWidget {
  final Function(int) onNavigate;

  const HomePage({super.key, required this.onNavigate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString(kLoggedInUsernameKey) ?? 'Pengguna';
    });
  }

  void _navigateToMenu(String menuTitle) {
    switch (menuTitle) {
      case 'Product Recommendation':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductRecommendationPage(onNavigate: widget.onNavigate),
          ),
        );
        break;
      case 'Makeup Tips':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MakeupTipsPage(),
          ),
        );
        break;
      case 'Makeup Tools':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MakeupToolsPage(),
          ),
        );
        break;
      default:
     
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$menuTitle - Coming Soon!'),
            backgroundColor: Colors.pink,
          ),
        );
    }
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $_username! 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'What would you like to explore today?',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.pinkAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Discover Your Beauty',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore makeup tips, tools, and find your perfect products',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildMenuCard(
                    title: 'Makeup Tips',
                    subtitle: 'Learn beauty tricks',
                    icon: Icons.lightbulb_outline,
                    color: Colors.purple,
                    onTap: () => _navigateToMenu('Makeup Tips'),
                  ),
                  _buildMenuCard(
                    title: 'Makeup Tools',
                    subtitle: 'Explore essentials',
                    icon: Icons.brush,
                    color: Colors.orange,
                    onTap: () => _navigateToMenu('Makeup Tools'),
                  ),
                  _buildMenuCard(
                    title: 'Product Recommendation',
                    subtitle: 'Find your products',
                    icon: Icons.shopping_bag,
                    color: Colors.pink,
                    onTap: () => _navigateToMenu('Product Recommendation'),
                  ),
                  _buildMenuCard(
                    title: 'Beauty Trends',
                    subtitle: 'Stay updated',
                    icon: Icons.trending_up,
                    color: Colors.teal,
                    onTap: () => _navigateToMenu('Beauty Trends'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SchedulePage(onNavigate: widget.onNavigate),
                    ),
                  );
                },
                child: _buildFeatureCard(
                  icon: Icons.calendar_today,
                  title: 'Beauty Reminders',
                  subtitle: 'Never miss your beauty routine',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
        ],
      ),
    );
  }
}
