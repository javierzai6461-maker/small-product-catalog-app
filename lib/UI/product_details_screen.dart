import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../function/product_detail_fn.dart';
import '../../constant/view_state.dart';
import 'widgets/state_views.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailFn _detailFn;

  @override
  void initState() {
    super.initState();
    _detailFn = ProductDetailFn();
    _detailFn.fetchProductDetail(widget.productId);
  }

  @override
  void dispose() {
    _detailFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: AnimatedBuilder(
        animation: _detailFn,
        builder: (context, child) {
          switch (_detailFn.state) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return ErrorView(
                message: _detailFn.errorMessage,
                onRetry: () => _detailFn.fetchProductDetail(widget.productId),
              );
            case ViewState.empty:
            case ViewState.success:
              final product = _detailFn.product!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        itemCount: product.images.isNotEmpty
                            ? product.images.length
                            : 1,
                        itemBuilder: (context, index) {
                          final imageUrl = product.images.isNotEmpty
                              ? product.images[index]
                              : product.thumbnail;
                          return imageUrl.startsWith('http')
                              ? CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                )
                              : Image.asset(imageUrl, fit: BoxFit.contain);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
