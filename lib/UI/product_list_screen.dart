import 'package:flutter/material.dart';
import 'package:small_product_catalog_app/UI/product_details_screen.dart';
import 'package:small_product_catalog_app/UI/widgets/product_card.dart';
import 'package:small_product_catalog_app/UI/widgets/state_views.dart';
import 'package:small_product_catalog_app/model/product_md.dart';

enum MockState { loading, error, empty, success }

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  MockState currentState = MockState.success;

  final List<ProductModel> mockProducts = [
    ProductModel(
      id: 1,
      title: 'iPhone 15 Pro',
      description: 'The latest iPhone',
      price: 999.0,
      rating: 4.8,
      thumbnail: 'https://cdn.dummyjson.com/products/images/smartphones/iPhone%2013%20Pro/thumbnail.png',
      images: [],
    ),
    ProductModel(
      id: 2,
      title: 'MacBook Air M2',
      description: 'Super fast laptop',
      price: 1199.0,
      rating: 4.9,
      thumbnail: 'https://cdn.dummyjson.com/products/images/laptops/Apple%20MacBook%20Pro%2014%20Inch%20Space%20Grey/thumbnail.png',
      images: [],
    ),
  ];

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
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (currentState) {
      case MockState.loading:
        return const LoadingView();
      case MockState.error:
        return ErrorView(
          message: 'Failed to connect to the server.',
          onRetry: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Retrying...')));
          },
        );
      case MockState.empty:
        return const EmptyView();
      case MockState.success:
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: mockProducts.length,
          itemBuilder: (context, index) {
            final product = mockProducts[index];
            return ProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
            );
          },
        );
    }
  }
}
