import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/resources/app_text.dart';
import 'package:textiles/screens/user/category_products_screen.dart';
import 'package:textiles/screens/user/product_details_screen.dart';
import 'package:textiles/screens/user/search_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/resources/app_images.dart';
import 'package:textiles/widgets/product_card.dart';
import 'package:textiles/widgets/user_drawer.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final banner = store.activeBanner;
    final arrivals = store.newArrivals;
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: const TextilesAppBar(title: AppText.brandTitle, titleColor: AppColors.green, showMenu: true, showCart: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          TextField(
            readOnly: true,
            onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const SearchScreen())),
            decoration: InputDecoration(
              hintText: 'Search T-Shirts, Linens...',
              prefixIcon: const Icon(Icons.search, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.field,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              GestureDetector(
                onTap: store.clearSearches,
                child: const Text('Clear All', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final term in store.recentSearches)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(term),
                      backgroundColor: const Color(0xFFF1F1F1),
                      side: BorderSide.none,
                      onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => SearchScreen(initialQuery: term))),
                    ),
                  ),
              ],
            ),
          ),
          if (banner != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      banner.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(color: Color(0xFFE7E2D8)),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withValues(alpha: 0.55), Colors.black.withValues(alpha: 0.05)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: AppColors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(banner.eyebrow, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                          ),
                          const Spacer(),
                          Text(banner.title, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, height: 1.05)),
                          const SizedBox(height: 10),
                          FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.ink),
                            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const CategoryProductsScreen(categoryId: 'winter'))),
                            child: Text('${banner.action}  →'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Text('Categories(Men)', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _categoryBubble(
                context,
                label: 'T-Shirts',
                image: AppImages.monkeyTee,
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const CategoryProductsScreen(categoryId: 'tshirts'))),
              ),
              _categoryBubble(
                context,
                label: 'Shirts',
                image: AppImages.stripeShirt,
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const CategoryProductsScreen(categoryId: 'shirts'))),
              ),
              _categoryBubble(
                context,
                label: 'Jeans',
                image: AppImages.blackJeans,
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const CategoryProductsScreen(categoryId: 'jeans'))),
              ),
              _moreBubble(context),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('New Arrivals', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    SizedBox(height: 2),
                    Text('The latest curated textiles for your home.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const CategoryProductsScreen(categoryId: 'new'))),
                child: const Text('View\nAll', textAlign: TextAlign.right, style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800, decoration: TextDecoration.underline)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: arrivals.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 12, childAspectRatio: 0.62),
            itemBuilder: (context, index) {
              final product = arrivals[index];
              return ProductCard(
                product: product,
                showHeart: true,
                showRating: true,
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => ProductDetailsScreen(productId: product.id))),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(index: 0),
    );
  }

  Widget _categoryBubble(BuildContext context, {required String label, required String image, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            ClipOval(
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(color: Color(0xFFF3F1EC), child: Icon(Icons.checkroom_outlined)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _moreBubble(BuildContext context) {
    return GestureDetector(
      onTap: () => selectTab(context, 1),
      child: const SizedBox(
        width: 76,
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              child: Icon(Icons.more_horiz, color: AppColors.ink),
            ),
            SizedBox(height: 8),
            Text('More', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
