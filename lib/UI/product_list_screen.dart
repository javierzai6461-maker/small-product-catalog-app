import 'package:flutter/material.dart';
import 'package:small_product_catalog_app/UI/product_details_screen.dart';

import '../../function/product_list_fn.dart';
import '../constant/view_state.dart';
import 'widgets/product_card.dart';
import 'widgets/state_views.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductListFn _productListFn;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productListFn = ProductListFn();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _productListFn.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification ||
        notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels >=
          notification.metrics.maxScrollExtent - 200) {
        _productListFn.loadMore();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Catalog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, child) {
                return TextField(
                  controller: _searchController,
                  onChanged: _productListFn.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _productListFn.onSearchChanged('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _productListFn,
        builder: (context, child) {
          return RefreshIndicator(
            onRefresh: () => _productListFn.fetchProducts(refresh: true),
            child: _buildBody(),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_productListFn.state) {
      case ViewState.loading:
        return const LoadingView();
      case ViewState.error:
        return ErrorView(
          message: _productListFn.errorMessage,
          onRetry: () => _productListFn.fetchProducts(refresh: true),
        );
      case ViewState.empty:
        return const EmptyView();
      case ViewState.success:
        return NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _productListFn.products.length,
                  itemBuilder: (context, index) {
                    final product = _productListFn.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(productId: product.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (_productListFn.isFetchingMore)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
    }
  }
}
