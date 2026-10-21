import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/product_details_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/product_card.dart';
import 'package:textiles/widgets/user_drawer.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final match = store.categories.where((item) => item.id == categoryId);
    final title = categoryId == 'new' ? 'New Arrivals' : (match.isEmpty ? categoryId : match.first.name);
    final products = store.productsForCategory(categoryId);
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: const TextilesAppBar(title: 'Category', titleColor: AppColors.green, showBack: true, showCart: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        children: [
          Row(
            children: [
              IconButton(onPressed: () => goBack(context), icon: const Icon(Icons.arrow_back)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    if (match.isNotEmpty)
                      Text(match.first.blurb, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 12, childAspectRatio: 0.62),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                showRating: true,
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => ProductDetailsScreen(productId: product.id))),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(index: 1),
    );
  }
}
