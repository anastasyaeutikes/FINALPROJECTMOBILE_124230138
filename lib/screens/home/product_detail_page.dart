import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/product_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedCurrency = "USD";

  // Simulasi konversi rate (dummy)
  final Map<String, double> currencyRate = {
    "USD": 1.0,
    "EUR": 0.93,
    "IDR": 15500,
    "JPY": 154,
  };

  double convertPrice(double basePrice, String currency) {
    return basePrice * currencyRate[currency]!;
  }

  @override
  Widget build(BuildContext context) {
    final basePrice = double.tryParse(widget.product.price) ?? 0.0;

    String formattedPrice = basePrice == 0
        ? "Price not available"
        : "${convertPrice(basePrice, selectedCurrency).toStringAsFixed(2)} $selectedCurrency";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Hero(
                tag: 'product_${widget.product.id}',
                child: widget.product.imageLink.isNotEmpty
                    ? Image.network(
                        widget.product.imageLink,
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 300,
                          color: Colors.grey.shade200,
                          child:
                              const Icon(Icons.image_not_supported, size: 100),
                        ),
                      )
                    : Container(
                        height: 300,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, size: 100),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    widget.product.brand.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product Name
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Currency Dropdown + Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price Select
                      DropdownButton<String>(
                        value: selectedCurrency,
                        items: ["USD", "EUR", "IDR", "JPY"]
                            .map((currency) => DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCurrency = value!;
                          });
                        },
                      ),

                      // Price Text
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Product Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.product.productType.toUpperCase(),
                      style: TextStyle(
                        color: Colors.pink.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 16),

                  // Description Title
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Description Body
                  widget.product.description.isNotEmpty
                      ? Text(
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.justify,
                        )
                      : Text(
                          'No description available for this product.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                  const SizedBox(height: 24),

                  // Product Website Info
                  if (widget.product.websiteLink.isNotEmpty) ...[
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.public,
                            size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Official Brand Website Available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],

                  const SizedBox(height: 30),

                  // BUY BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = Uri.parse(widget.product.websiteLink);

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cannot open website'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                      ),
                      child: const Text(
                        'Buy Product',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
