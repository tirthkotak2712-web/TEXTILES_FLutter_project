import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/format.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/shipping_address_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/common.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final product = store.productById(widget.productId);
    if (product == null) return const Scaffold(body: Center(child: Text('Product unavailable')));
    final wished = store.isWished(product.id);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: Image.asset(product.image, fit: BoxFit.contain)),
                SafeArea(
                  child: Row(
                    children: [
                      IconButton(onPressed: () => goBack(context), icon: const Icon(Icons.arrow_back)),
                      const Spacer(),
                      IconButton(
                        onPressed: () => store.toggleWishlist(product.id),
                        icon: Icon(wished ? Icons.favorite : Icons.favorite_border, color: wished ? AppColors.danger : AppColors.ink),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                Text('${product.rating.toStringAsFixed(1)}  (${product.reviewCount} Reviews)'),
                const SizedBox(height: 8),
                Text(Format.inr(product.price), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(product.description),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    QtyStepper(quantity: _quantity, onChanged: (value) { if (value >= 1) setState(() => _quantity = value); }),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          store.addToCart(product.id, quantity: _quantity);
                          showAppMessage(context, '${product.name} added to cart');
                        },
                        child: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Buy Now',
                        onPressed: () {
                          store.addToCart(product.id, quantity: _quantity);
                          Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ShippingAddressScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
