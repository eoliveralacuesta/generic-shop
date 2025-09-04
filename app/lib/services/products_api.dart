import 'dart:convert';
import 'package:app/models/product_result.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductsApi {
  static const String baseUrl = 'http://localhost:8080/products';

  // Obtener productos con filtros
  static Future<ProductsResult> getProducts({
    String? q,
    String? category,
    bool? oos,
    int? limit,
    int? offset,
  }) async {
    final queryParameters = <String, String>{};

    if (q != null && q.isNotEmpty) queryParameters['q'] = q;
    if (category != null && category.isNotEmpty) queryParameters['category'] = category;
    if (oos != null && oos) queryParameters['oos'] = 'true';
    if (limit != null) queryParameters['limit'] = limit.toString();
    if (offset != null) queryParameters['offset'] = offset.toString();

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200 || response.statusCode == 307) {
       final data = jsonDecode(response.body);
      return ProductsResult.fromJson(data);
    } else {
      throw Exception('Error al obtener productos: ${response.statusCode}');
    }
  }

  // Obtener producto por ID
  static Future<Product> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener producto por ID');
    }
  }

  // Obtener producto por SKU
  static Future<Product> getProductBySku(String sku) async {
    final response = await http.get(Uri.parse('$baseUrl/sku/$sku'));
    if (response.statusCode == 200 || response.statusCode == 307) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener producto por SKU');
    }
  }
}
