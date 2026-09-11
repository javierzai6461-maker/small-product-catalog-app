import 'package:flutter/material.dart';
import 'package:small_product_catalog_app/model/product_md.dart';

import '../API/api_client.dart';
import '../constant/view_state.dart';

class ProductDetailFn extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  ViewState state = ViewState.loading;
  String errorMessage = '';
  ProductModel? product;

  void fetchProductDetail(int id) async {
    state = ViewState.loading;
    notifyListeners();

    try {
      product = await _apiClient.getProductDetail(id);
      state = ViewState.success;
    } catch (e) {
      state = ViewState.error;
      errorMessage =
          'Failed to load product detail. Please check your connection.';
    } finally {
      notifyListeners();
    }
  }
}
