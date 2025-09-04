import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoriesApi {
  static const String baseUrl = 'http://localhost:8080/categories';

  // Obtener categorías
  static Future<List<Category>> getCategories() async {
    final queryParameters = <String, String>{};

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200 || response.statusCode == 307) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List<dynamic>;
      return items.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener categorías: ${response.statusCode}');
    }
  }
}
