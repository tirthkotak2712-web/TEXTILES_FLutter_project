import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/screens/user/cart_screen.dart';
import 'package:textiles/screens/user/categories_screen.dart';
import 'package:textiles/screens/user/profile_screen.dart';
import 'package:textiles/screens/user/shop_screen.dart';

class UserShell extends StatelessWidget {
  const UserShell({super.key});

  @override
  Widget build(BuildContext context) {
    final index = context.watch<StoreRepository>().tabIndex;
    return PopScope(
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.read<StoreRepository>().setTab(0);
      },
      child: IndexedStack(
        index: index,
        children: const [
          ShopScreen(),
          CategoriesScreen(),
          CartScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
