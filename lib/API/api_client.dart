import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:small_product_catalog_app/model/pagination_md.dart';
import 'package:small_product_catalog_app/model/product_md.dart';

class ApiClient {
  static const String _baseUrl = 'https://dummyjson.com';

  /// Fetches list of products
  Future<PaginatedResponse> getProducts({int limit = 20, int skip = 0}) async {
    final url = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return PaginatedResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load products');
    }
  }

  /// Fetches product detail by ID
  Future<ProductModel> getProductDetail(int id) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return ProductModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load product detail');
    }
  }

  /// Searches product
  Future<PaginatedResponse> searchProducts(String query) async {
    final url = Uri.parse('$_baseUrl/products/search?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return PaginatedResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to search products');
    }
  }
}
