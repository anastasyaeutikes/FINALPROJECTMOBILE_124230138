import 'package:flutter/material.dart';

class MakeupToolsPage extends StatefulWidget {
  const MakeupToolsPage({super.key});

  @override
  State<MakeupToolsPage> createState() => _MakeupToolsPageState();
}

class _MakeupToolsPageState extends State<MakeupToolsPage> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view},
    {'name': 'Brushes', 'icon': Icons.brush},
    {'name': 'Sponges', 'icon': Icons.circle},
    {'name': 'Tools', 'icon': Icons.build},
    {'name': 'Accessories', 'icon': Icons.star},
  ];

  final List<Map<String, dynamic>> _makeupTools = [
    {
      'name': 'Foundation Brush',
      'category': 'Brushes',
      'icon': Icons.brush,
      'color': Colors.orange,
      'description':
          'A dense, flat-topped brush perfect for applying liquid or cream foundation with a flawless, airbrushed finish.',
      'uses': [
        'Applying liquid foundation',
        'Cream foundation application',
        'Creating smooth, even coverage',
      ],
      'care': [
        'Wash weekly with gentle soap or brush cleanser',
        'Rinse thoroughly with lukewarm water',
        'Reshape bristles and lay flat to dry',
        'Never dry standing upright',
        'Store in a dry, clean place',
      ],
      'tips': [
        'Use stippling motions for fuller coverage',
        'Buff in circular motions for a natural finish',
        'Clean after every use for best results',
      ],
    },
    {
      'name': 'Beauty Sponge',
      'category': 'Sponges',
      'icon': Icons.circle,
      'color': Colors.pink,
      'description':
          'A versatile makeup sponge that expands when wet, perfect for blending foundation, concealer, and cream products seamlessly.',
      'uses': [
        'Blending liquid foundation',
        'Applying concealer',
        'Setting powder application',
        'Cream contour blending',
      ],
      'care': [
        'Wet before each use for best results',
        'Wash after every use with gentle soap',
        'Squeeze out excess water and air dry',
        'Replace every 3 months',
        'Store in a ventilated area',
      ],
      'tips': [
        'Use damp, never completely wet',
        'Bounce, don\'t drag across skin',
        'Use pointed end for precision areas',
      ],
    },
    {
      'name': 'Eyeshadow Brush Set',
      'category': 'Brushes',
      'icon': Icons.palette,
      'color': Colors.purple,
      'description':
          'A collection of essential eye brushes including flat shader, blending brush, and precision crease brush for creating any eye look.',
      'uses': [
        'Applying eyeshadow to lids',
        'Blending colors seamlessly',
        'Precise crease definition',
        'Highlighting inner corners',
      ],
      'care': [
        'Clean at least once a week',
        'Use brush shampoo or gentle cleanser',
        'Dry flat or hanging upside down',
        'Avoid getting water in the ferrule',
        'Store separately to maintain shape',
      ],
      'tips': [
        'Use different brushes for different colors',
        'Start with lighter colors first',
        'Tap off excess powder before applying',
      ],
    },
    {
      'name': 'Eyelash Curler',
      'category': 'Tools',
      'icon': Icons.remove_red_eye,
      'color': Colors.blue,
      'description':
          'A metal tool designed to curl and lift eyelashes before mascara application for a wide-eyed, dramatic look.',
      'uses': [
        'Curling natural lashes',
        'Opening up the eyes',
        'Creating dramatic eye looks',
      ],
      'care': [
        'Clean rubber pad after each use',
        'Replace rubber pad every 3 months',
        'Wipe metal parts with alcohol',
        'Store in protective case',
        'Check for rust regularly',
      ],
      'tips': [
        'Always curl before applying mascara',
        'Hold for 10 seconds for best results',
        'Use at lash base, middle, and tips',
        'Never pull or tug on lashes',
      ],
    },
    {
      'name': 'Powder Brush',
      'category': 'Brushes',
      'icon': Icons.wb_sunny,
      'color': Colors.amber,
      'description':
          'A large, fluffy brush ideal for applying setting powder, bronzer, or blush with a light, natural finish.',
      'uses': [
        'Setting makeup with powder',
        'Applying bronzer',
        'Blush application',
        'Dusting off excess product',
      ],
      'care': [
        'Wash every 1-2 weeks',
        'Use mild shampoo or brush cleanser',
        'Dry completely before storing',
        'Fluff bristles while drying',
        'Keep away from heat',
      ],
      'tips': [
        'Tap off excess powder before applying',
        'Use light, sweeping motions',
        'Perfect for baking technique',
      ],
    },
    {
      'name': 'Makeup Brush Cleaner',
      'category': 'Accessories',
      'icon': Icons.cleaning_services,
      'color': Colors.teal,
      'description':
          'A specialized solution or mat designed to deep clean makeup brushes, removing makeup residue, bacteria, and buildup.',
      'uses': [
        'Deep cleaning makeup brushes',
        'Removing stubborn makeup residue',
        'Sanitizing brush bristles',
        'Extending brush lifespan',
      ],
      'care': [
        'Store in cool, dry place',
        'Close cap tightly after use',
        'Check expiration date',
        'Keep away from direct sunlight',
      ],
      'tips': [
        'Use weekly for best hygiene',
        'Swirl brushes gently on cleaning mat',
        'Rinse thoroughly with water',
        'Can add a drop to daily spot cleaning',
      ],
    },
    {
      'name': 'Makeup Spatula',
      'category': 'Tools',
      'icon': Icons.horizontal_rule,
      'color': Colors.grey,
      'description':
          'A small, flat tool perfect for scooping out cream products hygienically and mixing custom shades on a mixing palette.',
      'uses': [
        'Scooping cream products',
        'Mixing foundation shades',
        'Applying face masks',
        'Preventing contamination',
      ],
      'care': [
        'Wash after every use',
        'Dry completely before storing',
        'Use rubbing alcohol for sanitizing',
        'Store in clean container',
      ],
      'tips': [
        'Use to extend product shelf life',
        'Perfect for hygiene-conscious users',
        'Great for mixing custom colors',
      ],
    },
    {
      'name': 'Lip Brush',
      'category': 'Brushes',
      'icon': Icons.water_drop,
      'color': Colors.red,
      'description':
          'A small, precision brush designed for precise lipstick application and creating perfect lip lines.',
      'uses': [
        'Precise lipstick application',
        'Defining lip contours',
        'Filling in lips evenly',
        'Creating ombre lip looks',
      ],
      'care': [
        'Clean after each use',
        'Use gentle brush cleaner or soap',
        'Rinse with lukewarm water',
        'Reshape tip while drying',
        'Store in protective cap',
      ],
      'tips': [
        'Line lips before filling',
        'Blend multiple lipstick shades',
        'Perfect for bold, dark colors',
      ],
    },
    {
      'name': 'Tweezers',
      'category': 'Tools',
      'icon': Icons.content_cut,
      'color': Colors.green,
      'description':
          'Precision grooming tool for shaping eyebrows, applying false lashes, and removing unwanted facial hair.',
      'uses': [
        'Shaping eyebrows',
        'Applying false eyelashes',
        'Removing stray hairs',
        'Precision makeup corrections',
      ],
      'care': [
        'Wipe clean after each use',
        'Disinfect with rubbing alcohol weekly',
        'Keep tips aligned and sharp',
        'Store in protective case',
        'Never share with others',
      ],
      'tips': [
        'Tweeze in direction of hair growth',
        'Use after a warm shower',
        'Work in natural lighting',
        'Don\'t over-pluck eyebrows',
      ],
    },
    {
      'name': 'Makeup Mirror (LED)',
      'category': 'Accessories',
      'icon': Icons.photo_camera_front,
      'color': Colors.cyan,
      'description':
          'A illuminated mirror with adjustable brightness settings, providing perfect lighting for flawless makeup application.',
      'uses': [
        'Detailed makeup application',
        'Checking makeup in different lights',
        'Precise eye and lip work',
        'Skincare routine',
      ],
      'care': [
        'Clean glass with microfiber cloth',
        'Use glass cleaner weekly',
        'Keep away from water',
        'Wipe LED lights gently',
        'Store in dust-free area',
      ],
      'tips': [
        'Use daylight setting for most accurate color',
        'Adjust brightness for different looks',
        'Perfect for travel',
      ],
    },
    {
      'name': 'Contour Brush',
      'category': 'Brushes',
      'icon': Icons.face,
      'color': Colors.brown,
      'description':
          'An angled brush specifically designed for precise contour application, creating defined cheekbones and sculpted features.',
      'uses': [
        'Applying contour powder or cream',
        'Sculpting cheekbones',
        'Nose contouring',
        'Jawline definition',
      ],
      'care': [
        'Wash weekly with brush cleanser',
        'Maintain angled shape while drying',
        'Store angle-side up',
        'Deep clean monthly',
      ],
      'tips': [
        'Use the angle to fit under cheekbones',
        'Blend upward for natural look',
        'Works with powder and cream products',
      ],
    },
    {
      'name': 'Makeup Bag Organizer',
      'category': 'Accessories',
      'icon': Icons.shopping_bag,
      'color': Colors.indigo,
      'description':
          'A compartmentalized bag designed to store and organize all your makeup tools, brushes, and products efficiently.',
      'uses': [
        'Organizing makeup collection',
        'Protecting brushes and tools',
        'Travel makeup storage',
        'Keeping products clean',
      ],
      'care': [
        'Empty and clean monthly',
        'Wipe interior with damp cloth',
        'Air dry completely',
        'Check for product spills regularly',
        'Machine wash if fabric (check label)',
      ],
      'tips': [
        'Use dividers for better organization',
        'Store brushes upright when possible',
        'Keep most-used items accessible',
      ],
    },
  ];

  List<Map<String, dynamic>> _getFilteredTools() {
    if (_selectedCategory == 'All') {
      return _makeupTools;
    }
    return _makeupTools
        .where((tool) => tool['category'] == _selectedCategory)
        .toList();
  }

  void _showToolDetail(Map<String, dynamic> tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (tool['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          tool['icon'] as IconData,
                          color: tool['color'] as Color,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tool['name'] as String,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (tool['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tool['category'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: tool['color'] as Color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    tool['description'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'How to Use',
                    Icons.lightbulb_outline,
                    tool['uses'] as List<String>,
                    Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Care Instructions',
                    Icons.favorite_border,
                    tool['care'] as List<String>,
                    Colors.red,
                  ),
                  if (tool.containsKey('tips')) ...[
                    const SizedBox(height: 20),
                    _buildSection(
                      'Pro Tips',
                      Icons.star_border,
                      tool['tips'] as List<String>,
                      Colors.amber,
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, IconData icon, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(Map<String, dynamic> category) {
    final isSelected = _selectedCategory == category['name'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category['name'] as String;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orange.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category['icon'] as IconData,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              category['name'] as String,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(Map<String, dynamic> tool) {
    return GestureDetector(
      onTap: () => _showToolDetail(tool),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (tool['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tool['icon'] as IconData,
                  color: tool['color'] as Color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tool['category'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTools = _getFilteredTools();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Makeup Tools',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Essential tools and care guide',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Essential\nBeauty Arsenal',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Learn about tools and proper care',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.brush,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Categories
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _categories
                      .map(
                        (cat) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _buildCategoryChip(cat),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Tools Count
              Text(
                '${filteredTools.length} Tools Available',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Tools List
              ...filteredTools.map((tool) => _buildToolCard(tool)),
            ],
          ),
        ),
      ),
    );
  }
}
