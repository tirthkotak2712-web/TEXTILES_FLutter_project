import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/product_details_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final items = store.wishlistProducts;
    return Scaffold(
      appBar: const TextilesAppBar(title: 'Wishlist', titleColor: AppColors.green, showBack: true, showCart: true),
      body: items.isEmpty
          ? const Center(child: Text('Save pieces with the heart icon.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 12, childAspectRatio: 0.68),
              itemBuilder: (context, index) {
                final product = items[index];
                return ProductCard(
                  product: product,
                  showHeart: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => ProductDetailsScreen(productId: product.id))),
                );
              },
            ),
      bottomNavigationBar: const AppBottomNav(index: 3),
    );
  }
}
