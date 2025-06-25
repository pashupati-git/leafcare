import 'dart:convert';
import 'package:http/http.dart' as http;

class ConstantFunction {
  static const String _baseUrl = 'https://api.escuelajs.co/api/v1';

  /// Fetch all categories (optional use)
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    const String apiUrl = '$_baseUrl/categories';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    return [];
  }

  /// Fetch all products (flat list)
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    const String apiUrl = '$_baseUrl/products';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
    return [];
  }

  /// Fetch products and group them by category name
  /// Now includes all categories (even with zero products)
  static Future<Map<String, List<Map<String, dynamic>>>> fetchGroupedProductsByCategory() async {
    try {
      final categories = await fetchCategories();  // fetch all categories
      final products = await fetchProducts();

      // Initialize map with all categories and empty product lists
      final Map<String, List<Map<String, dynamic>>> grouped = {
        for (var cat in categories) cat['name'] ?? 'Unknown': []
      };

      // Add products to their respective categories
      for (var product in products) {
        final category = product['category'];
        if (category != null) {
          final categoryName = category['name'] ?? 'Unknown';
          grouped[categoryName]?.add(product);
        }
      }

      return grouped;
    } catch (e) {
      print('Error grouping products by category: $e');
      return {};
    }
  }
}
