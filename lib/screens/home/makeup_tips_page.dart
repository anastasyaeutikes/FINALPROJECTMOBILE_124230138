import 'package:flutter/material.dart';

class MakeupTipsPage extends StatefulWidget {
  const MakeupTipsPage({super.key});

  @override
  State<MakeupTipsPage> createState() => _MakeupTipsPageState();
}

class _MakeupTipsPageState extends State<MakeupTipsPage> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view},
    {'name': 'Face', 'icon': Icons.face},
    {'name': 'Eyes', 'icon': Icons.remove_red_eye},
    {'name': 'Lips', 'icon': Icons.favorite},
    {'name': 'Skin Care', 'icon': Icons.spa},
  ];

  final List<Map<String, dynamic>> _makeupTips = [
    {
      'title': 'Perfect Foundation Application',
      'category': 'Face',
      'difficulty': 'Beginner',
      'time': '10 min',
      'icon': Icons.face_retouching_natural,
      'color': Colors.orange,
      'tips': [
        'Start with a clean, moisturized face',
        'Use a primer to create a smooth base',
        'Apply foundation in the center of your face and blend outward',
        'Use a damp beauty sponge for a natural finish',
        'Set with translucent powder for longevity',
      ],
    },
    {
      'title': 'Winged Eyeliner Tutorial',
      'category': 'Eyes',
      'difficulty': 'Intermediate',
      'time': '15 min',
      'icon': Icons.edit,
      'color': Colors.blue,
      'tips': [
        'Start with an eyeshadow base',
        'Draw a thin line along your upper lash line',
        'Create the wing by extending the line upward',
        'Connect the wing to your lash line',
        'Fill in any gaps and perfect the shape',
      ],
    },
    {
      'title': 'Natural Everyday Look',
      'category': 'Face',
      'difficulty': 'Beginner',
      'time': '20 min',
      'icon': Icons.light_mode,
      'color': Colors.pink,
      'tips': [
        'Use tinted moisturizer or light foundation',
        'Conceal only problem areas',
        'Add a touch of blush to cheeks',
        'Fill in eyebrows naturally',
        'Finish with mascara and tinted lip balm',
      ],
    },
    {
      'title': 'Smokey Eye Technique',
      'category': 'Eyes',
      'difficulty': 'Advanced',
      'time': '25 min',
      'icon': Icons.visibility,
      'color': Colors.purple,
      'tips': [
        'Start with an eyeshadow primer',
        'Apply a light shade all over the lid',
        'Add a medium shade to the crease',
        'Use a dark shade on the outer corner',
        'Blend everything seamlessly',
        'Line with black eyeliner and smudge',
        'Finish with several coats of mascara',
      ],
    },
    {
      'title': 'Long-Lasting Lipstick',
      'category': 'Lips',
      'difficulty': 'Beginner',
      'time': '5 min',
      'icon': Icons.water_drop,
      'color': Colors.red,
      'tips': [
        'Exfoliate lips gently',
        'Apply a lip primer or concealer',
        'Line lips with a matching lip liner',
        'Fill in lips completely with liner',
        'Apply lipstick over the liner',
        'Blot with tissue and reapply for extra staying power',
      ],
    },
    {
      'title': 'Contouring for Beginners',
      'category': 'Face',
      'difficulty': 'Beginner',
      'time': '15 min',
      'icon': Icons.face,
      'color': Colors.brown,
      'tips': [
        'Choose a contour shade 2 shades darker than your skin',
        'Apply under cheekbones in a "3" shape',
        'Contour along the hairline and jawline',
        'Blend thoroughly with a beauty sponge',
        'Add highlighter to high points of face',
      ],
    },
    {
      'title': 'Skincare Before Makeup',
      'category': 'Skin Care',
      'difficulty': 'Beginner',
      'time': '10 min',
      'icon': Icons.spa,
      'color': Colors.green,
      'tips': [
        'Cleanse your face thoroughly',
        'Apply toner to balance pH',
        'Use a serum for specific concerns',
        'Apply eye cream gently',
        'Moisturize and wait for absorption',
        'Always use SPF before makeup',
      ],
    },
    {
      'title': 'False Lashes Application',
      'category': 'Eyes',
      'difficulty': 'Intermediate',
      'time': '10 min',
      'icon': Icons.remove_red_eye_outlined,
      'color': Colors.indigo,
      'tips': [
        'Measure and trim lashes to fit your eye',
        'Apply lash glue and wait 30 seconds',
        'Place lashes as close to your lash line as possible',
        'Press down gently, especially at corners',
        'Apply eyeliner to hide the lash band',
      ],
    },
    {
      'title': 'Glowing Skin Makeup',
      'category': 'Face',
      'difficulty': 'Intermediate',
      'time': '20 min',
      'icon': Icons.wb_sunny,
      'color': Colors.amber,
      'tips': [
        'Start with a hydrating primer',
        'Use a dewy foundation or BB cream',
        'Mix liquid highlighter with foundation',
        'Apply cream blush for a natural flush',
        'Add powder highlighter on cheekbones',
        'Set only the T-zone with powder',
      ],
    },
    {
      'title': 'Perfect Brow Shaping',
      'category': 'Eyes',
      'difficulty': 'Beginner',
      'time': '10 min',
      'icon': Icons.gradient,
      'color': Colors.teal,
      'tips': [
        'Brush brows upward with a spoolie',
        'Fill in sparse areas with brow pencil',
        'Use short, hair-like strokes',
        'Set with a tinted or clear brow gel',
        'Highlight under the brow bone',
      ],
    },
  ];

  List<Map<String, dynamic>> _getFilteredTips() {
    if (_selectedCategory == 'All') {
      return _makeupTips;
    }
    return _makeupTips
        .where((tip) => tip['category'] == _selectedCategory)
        .toList();
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showTipDetail(Map<String, dynamic> tip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (tip['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          tip['icon'] as IconData,
                          color: tip['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['title'] as String,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tip['category'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.timer,
                        tip['time'] as String,
                        Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      _buildInfoChip(
                        Icons.signal_cellular_alt,
                        tip['difficulty'] as String,
                        _getDifficultyColor(tip['difficulty'] as String),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Step by Step Guide',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...(tip['tips'] as List<String>).asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color:
                                      (tip['color'] as Color).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: tip['color'] as Color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
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
          color: isSelected ? Colors.pink : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.pink.shade200,
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

  Widget _buildTipCard(Map<String, dynamic> tip) {
    return GestureDetector(
      onTap: () => _showTipDetail(tip),
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
                  color: (tip['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tip['icon'] as IconData,
                  color: tip['color'] as Color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.timer,
                          tip['time'] as String,
                          Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.signal_cellular_alt,
                          tip['difficulty'] as String,
                          _getDifficultyColor(tip['difficulty'] as String),
                        ),
                      ],
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
    final filteredTips = _getFilteredTips();

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
              'Makeup Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Learn professional techniques',
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
                    colors: [Colors.purple, Colors.purpleAccent],
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
                            'Master Your\nMakeup Skills',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Step-by-step tutorials for all levels',
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
                        Icons.lightbulb,
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

              // Tips Count
              Text(
                '${filteredTips.length} Tips Available',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Tips List
              ...filteredTips.map((tip) => _buildTipCard(tip)),
            ],
          ),
        ),
      ),
    );
  }
}
