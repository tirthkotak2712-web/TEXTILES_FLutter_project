import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/category_products_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/user_drawer.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<StoreRepository>().categories.where((category) => category.onGrid).toList();
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: const TextilesAppBar(title: 'Category', titleColor: AppColors.green, showMenu: true, showCart: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.95),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Material(
            color: const Color(0xFFF4FAF6),
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => CategoryProductsScreen(categoryId: category.id))),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: category.image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category.icon, size: 64),
                          const SizedBox(height: 12),
                          Text(category.id == 'shorts' ? 'Short' : category.name),
                        ],
                      )
                    : Image.asset(category.image!, fit: BoxFit.contain),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(index: 1),
    );
  }
}
