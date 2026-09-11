import 'product_md.dart';

class PaginatedResponse {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  int get perPage => limit > 0 ? limit : 20;
  int get currentPage => (skip / perPage).floor() + 1;
  int get lastPage => (total / perPage).ceil();

  PaginatedResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'] as List<dynamic>? ?? [];
    final productsList = rawProducts
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return PaginatedResponse(
      products: productsList,
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
