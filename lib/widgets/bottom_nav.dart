import 'package:flutter/material.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/widgets/app_bar.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _item(context, 0, Icons.storefront_outlined, Icons.storefront, 'Shop'),
              _item(context, 1, Icons.account_tree_outlined, Icons.account_tree, 'Categories'),
              _item(context, 2, Icons.shopping_cart_outlined, Icons.shopping_cart, 'Cart'),
              _item(context, 3, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int itemIndex,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final selected = index == itemIndex;
    final color = selected ? AppColors.green : const Color(0xFF6F6F6F);
    return Expanded(
      child: InkWell(
        onTap: () => selectTab(context, itemIndex),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? AppColors.greenSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(selected ? activeIcon : icon, color: color, size: 22),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
