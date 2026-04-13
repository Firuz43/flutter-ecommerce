class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  // This factory converts the JSON from your Go backend into a Dart object ///
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      // Go sends float64, which might come as int or double in JSON
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? '',
    );
  }
}