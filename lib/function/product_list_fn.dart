import 'dart:async';

import 'package:flutter/material.dart';
import 'package:small_product_catalog_app/model/product_md.dart';

import '../API/api_client.dart';
import '../constant/view_state.dart';

class ProductListFn extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  ViewState state = ViewState.loading;
  String errorMessage = '';

  List<ProductModel> products = [];
  int _skip = 0;
  final int _limit = 10;
  bool hasMore = true;
  bool isFetchingMore = false;

  // Search
  Timer? _debounceTimer;
  String _currentQuery = '';

  ProductListFn() {
    fetchProducts();
  }

  void onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      _currentQuery = query.trim();
      fetchProducts(refresh: true);
    });
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _skip = 0;
      hasMore = true;
      if (_currentQuery.isNotEmpty) {
        state = ViewState.loading;
        notifyListeners();
      }
    } else if (products.isEmpty) {
      state = ViewState.loading;
      notifyListeners();
    }

    try {
      if (_currentQuery.isNotEmpty) {
        final response = await _apiClient.searchProducts(_currentQuery);
        products = response.products;
        hasMore = false;
      } else {
        final response = await _apiClient.getProducts(
          skip: _skip,
          limit: _limit,
        );
        if (refresh) {
          products = response.products;
        } else {
          products.addAll(response.products);
        }
        _skip += _limit;
        hasMore = products.length < response.total;
      }

      if (products.isEmpty) {
        state = ViewState.empty;
      } else {
        state = ViewState.success;
      }
    } catch (e) {
      if (products.isEmpty || _currentQuery.isNotEmpty) {
        state = ViewState.error;
        errorMessage = 'Failed to load products. Please check your connection.';
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    // Disable load more if currently searching
    if (isFetchingMore ||
        !hasMore ||
        state != ViewState.success ||
        _currentQuery.isNotEmpty)
      return;

    isFetchingMore = true;
    notifyListeners();

    try {
      final response = await _apiClient.getProducts(skip: _skip, limit: _limit);
      products.addAll(response.products);
      _skip += _limit;
      hasMore = products.length < response.total;
    } catch (e) {
      // Ignore load more errors to not break existing list
    } finally {
      isFetchingMore = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
