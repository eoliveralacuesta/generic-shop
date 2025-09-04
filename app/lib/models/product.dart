class Product {
  final String sku;
  final String title;
  final double price;
  final String currency;
  final int stock;
  final double rating;
  final String image;

  Product({
    required this.sku,
    required this.title,
    required this.price,
    required this.currency,
    required this.stock,
    required this.rating,
    this.image = "img/default.jpg"
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      sku: json['sku'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      stock: json['stock'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      image: json['img'] ?? '',
    );
  }
}
