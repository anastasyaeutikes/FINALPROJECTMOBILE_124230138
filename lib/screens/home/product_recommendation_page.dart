import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/product_model.dart';
import 'product_detail_page.dart';

class ProductRecommendationPage extends StatefulWidget {
  final Function(int) onNavigate;

  const ProductRecommendationPage({super.key, required this.onNavigate});

  @override
  State<ProductRecommendationPage> createState() =>
      _ProductRecommendationPageState();
}

class _ProductRecommendationPageState extends State<ProductRecommendationPage> {
  List<Product> _allProducts = [];
  List<Product> _popularProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedProductType;
  String _hoveredType = '';

  final List<Map<String, dynamic>> _productTypes = [
    {
      'name': 'All Products',
      'type': null,
      'icon': Icons.grid_view,
      'color': Colors.grey.shade100,
    },
    {
      'name': 'Lipstick',
      'type': 'lipstick',
      'icon': Icons.water_drop,
      'color': Colors.red.shade100,
    },
    {
      'name': 'Lip Liner',
      'type': 'lip_liner',
      'icon': Icons.edit,
      'color': Colors.pink.shade100,
    },
    {
      'name': 'Foundation',
      'type': 'foundation',
      'icon': Icons.face,
      'color': Colors.orange.shade100,
    },
    {
      'name': 'Eyeliner',
      'type': 'eyeliner',
      'icon': Icons.remove_red_eye,
      'color': Colors.blue.shade100,
    },
    {
      'name': 'Eyeshadow',
      'type': 'eyeshadow',
      'icon': Icons.palette,
      'color': Colors.purple.shade100,
    },
    {
      'name': 'Mascara',
      'type': 'mascara',
      'icon': Icons.visibility,
      'color': Colors.indigo.shade100,
    },
    {
      'name': 'Blush',
      'type': 'blush',
      'icon': Icons.favorite,
      'color': Colors.pink.shade100,
    },
    {
      'name': 'Bronzer',
      'type': 'bronzer',
      'icon': Icons.wb_sunny,
      'color': Colors.brown.shade100,
    },
    {
      'name': 'Nail Polish',
      'type': 'nail_polish',
      'icon': Icons.color_lens,
      'color': Colors.cyan.shade100,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://makeup-api.herokuapp.com/api/v1/products.json'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final allProducts = data.map((json) => Product.fromJson(json)).toList();

        final validProducts = allProducts
            .where(
              (product) =>
                  product.imageLink.isNotEmpty &&
                  product.imageLink.startsWith('http'),
            )
            .toList();

        setState(() {
          _allProducts = allProducts;
          _popularProducts = validProducts.take(20).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError('Failed to load products');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error: $e');
    }
  }

  List<Product> _getFilteredProducts() {
    List<Product> filteredProducts = _allProducts;

    if (_selectedProductType != null) {
      final sel = _selectedProductType!.toLowerCase();
      filteredProducts = filteredProducts
          .where(
            (product) => product.productType.toLowerCase() == sel,
          )
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.productType.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
      }).toList();
    }

    return filteredProducts;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
    ).then((_) {
      setState(() {});
    });
  }

  void _onCategorySelected(String? productType) {
    setState(() {
      _selectedProductType = productType;
    });
  }

  Widget _buildCategoryChip(Map<String, dynamic> typeInfo) {
    final String? type = typeInfo['type'] as String?;
    final bool isSelected = _selectedProductType == type;
    final bool isHovered = _hoveredType == (type ?? 'all');

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredType = type ?? 'all';
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredType = '';
        });
      },
      child: GestureDetector(
        onTap: () => _onCategorySelected(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.pink
                : isHovered
                    ? (typeInfo['color'] as Color).withAlpha(204)
                    : typeInfo['color'] as Color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isHovered || isSelected
                    ? Colors.pink.shade200
                    : Colors.grey.shade300,
                blurRadius: isHovered || isSelected ? 8 : 3,
                offset: Offset(0, isHovered || isSelected ? 4 : 2),
              ),
            ],
            border: isSelected
                ? Border.all(color: Colors.pink.shade700, width: 2)
                : null,
          ),
          transform: isHovered && !isSelected
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                typeInfo['icon'] as IconData,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                typeInfo['name'] as String,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    String priceText = 'N/A';
    if (product.price.isNotEmpty && product.price != '0.0') {
      final priceSign = product.priceSign ?? '\$';
      priceText = '$priceSign${product.price}';
    }

    return GestureDetector(
      onTap: () => _navigateToProductDetail(product),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: product.imageLink.isNotEmpty
                  ? Image.network(
                      product.imageLink,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, size: 50),
                      ),
                    )
                  : Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    priceText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
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

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        String priceText = 'N/A';
        if (product.price.isNotEmpty && product.price != '0.0') {
          final priceSign = product.priceSign ?? '\$';
          priceText = '$priceSign${product.price}';
        }

        return GestureDetector(
          onTap: () => _navigateToProductDetail(product),
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: product.imageLink.isNotEmpty
                      ? Image.network(
                          product.imageLink,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 160,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                            ),
                          ),
                        )
                      : Container(
                          height: 160,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.brand,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        priceText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

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
              'Product Recommendation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Find your perfect beauty products',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProducts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search product...',
                      prefixIcon: const Icon(Icons.search, color: Colors.pink),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Product Type Categories
                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _productTypes
                        .map(
                          (typeInfo) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _buildCategoryChip(typeInfo),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),

                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(color: Colors.pink),
                    ),
                  )
                else if (_selectedProductType != null ||
                    _searchQuery.isNotEmpty) ...[
                  // Filtered Products
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'Search Results for "$_searchQuery"'
                        : '${_productTypes.firstWhere((t) => t['type'] == _selectedProductType)['name']} Products',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${filteredProducts.length} products found',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  filteredProducts.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text(
                              'No products found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : _buildProductGrid(filteredProducts),
                ] else ...[
                  // Popular Products
                  const Text(
                    'Popular Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _popularProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(_popularProducts[index]);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
