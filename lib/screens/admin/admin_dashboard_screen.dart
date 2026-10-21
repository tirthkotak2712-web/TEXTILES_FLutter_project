import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/format.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/admin/admin_drawer.dart';
import 'package:textiles/screens/admin/admin_nav.dart';
import 'package:textiles/screens/admin/admin_pages.dart';
import 'package:textiles/widgets/product_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final sellers = store.bestSellers;
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Admin DashBoard', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            onPressed: () => openAdminPage(context, const AdminNotificationsScreen()),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.line),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, size: 16),
                SizedBox(width: 8),
                Text('12 May - 18 May 2026'),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.45,
            children: [
              _stat(context, 'Total Revenue', Format.inr(StoreRepository.headlineRevenue), const AdminReportsScreen()),
              _stat(context, 'Total Order', '${StoreRepository.headlineOrders}', const AdminOrdersScreen()),
              _stat(context, 'Total Customers', '${StoreRepository.headlineCustomers}', const AdminCustomersScreen()),
              _stat(context, 'Products', '${StoreRepository.headlineProducts}', const AdminProductsScreen()),
              _stat(context, 'Pending Orders', '${StoreRepository.headlinePending}', const AdminOrdersScreen(initialFilter: 'Pending')),
              _stat(context, 'Low Stock Items', '${store.lowStockProducts.length}', const AdminInventoryScreen(lowOnly: true)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Best Sellers', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 8),
          for (final product in sellers)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: AppStyles.card(),
              child: Row(
                children: [
                  SizedBox(width: 56, height: 64, child: CatalogImage(image: product.image, radius: 8)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w800))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${product.weeklySales}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      const Text('SALES THIS\nWEEK', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, color: AppColors.muted)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String value, Widget page) {
    return InkWell(
      onTap: () => openAdminPage(context, page),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: AppStyles.card(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
