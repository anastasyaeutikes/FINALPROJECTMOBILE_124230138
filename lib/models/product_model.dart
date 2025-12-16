class Product {
  final int id;
  final String brand;
  final String name;
  final String price;
  final String? priceSign;
  final String? currency;
  final String imageLink;
  final String productLink;
  final String websiteLink;
  final String description;
  final double? rating;
  final String category;
  final String productType;
  final List<String> tagList;
  final List<ProductColor> productColors;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    this.priceSign,
    this.currency,
    required this.imageLink,
    required this.productLink,
    required this.websiteLink,
    required this.description,
    this.rating,
    required this.category,
    required this.productType,
    required this.tagList,
    required this.productColors,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      brand: json['brand'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '0.0',
      priceSign: json['price_sign'],
      currency: json['currency'],
      imageLink: json['image_link'] ?? '',
      productLink: json['product_link'] ?? '',
      websiteLink: json['website_link'] ?? '',
      description: json['description'] ?? '',
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      category: json['category'] ?? '',
      productType: json['product_type'] ?? '',
      tagList:
          json['tag_list'] != null ? List<String>.from(json['tag_list']) : [],
      productColors: json['product_colors'] != null
          ? (json['product_colors'] as List)
              .map((color) => ProductColor.fromJson(color))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'name': name,
      'price': price,
      'price_sign': priceSign,
      'currency': currency,
      'image_link': imageLink,
      'product_link': productLink,
      'website_link': websiteLink,
      'description': description,
      'rating': rating,
      'category': category,
      'product_type': productType,
      'tag_list': tagList,
      'product_colors': productColors.map((color) => color.toJson()).toList(),
    };
  }
}

class ProductColor {
  final String? hexValue;
  final String? colourName;

  ProductColor({
    this.hexValue,
    this.colourName,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      hexValue: json['hex_value'],
      colourName: json['colour_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hex_value': hexValue,
      'colour_name': colourName,
    };
  }
}
