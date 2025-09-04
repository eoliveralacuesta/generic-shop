// models/products_result.dart
import 'product.dart';

class ProductsResult {
  final List<Product> items;
  final int total;
  final int count;
  final int limit;
  final int offset;

  ProductsResult({
    required this.items,
    required this.total,
    required this.count,
    required this.limit,
    required this.offset,
  });

  factory ProductsResult.fromJson(Map<String, dynamic> json) {
    return ProductsResult(
      items: (json['items'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
      total: json['total'] as int,
      count: json['count'] as int,
      limit: json['limit'] as int,
      offset: json['offset'] as int,
    );
  }
}
