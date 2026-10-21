import 'package:flutter/material.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/resources/app_text.dart';
import 'package:textiles/screens/admin/admin_nav.dart';
import 'package:textiles/screens/admin/admin_pages.dart';
import 'package:textiles/screens/user/change_password_screen.dart';
import 'package:textiles/widgets/user_drawer.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.78,
      shape: const RoundedRectangleBorder(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.green,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 18),
            child: const Row(
              children: [
                CircleAvatar(radius: 28, backgroundColor: Color(0xFFD7EBD9), child: Icon(Icons.person, color: AppColors.greenDark)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admin', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                      Text(AppText.demoAdminEmail, style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.notifications_none, color: Colors.white),
              ],
            ),
          ),
          _item(context, Icons.home_outlined, 'Dashboard', null, selected: true),
          _item(context, Icons.inventory_2_outlined, 'Products', const AdminProductsScreen()),
          _item(context, Icons.list_alt, 'Categories', const AdminCategoriesScreen()),
          _item(context, Icons.shopping_basket_outlined, 'Inventory', const AdminInventoryScreen()),
          _item(context, Icons.receipt_long_outlined, 'Orders', const AdminOrdersScreen()),
          _item(context, Icons.people_outline, 'Customers', const AdminCustomersScreen()),
          _item(context, Icons.reviews_outlined, 'Reviews', const AdminReviewsScreen()),
          _item(context, Icons.confirmation_number_outlined, 'Coupons', const AdminCouponsScreen()),
          _item(context, Icons.image_outlined, 'Banners', const AdminBannersScreen()),
          _item(context, Icons.currency_rupee, 'Payments', const AdminPaymentsScreen()),
          _item(context, Icons.bar_chart_outlined, 'Reports', const AdminReportsScreen()),
          _item(context, Icons.notifications_none, 'Notifications', const AdminNotificationsScreen()),
          _item(context, Icons.settings_outlined, 'Settings', const AdminSettingsScreen()),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            onTap: () => openAdminPage(context, const ChangePasswordScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: const Text('Logout', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
            onTap: () => confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, Widget? page, {bool selected = false}) {
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.green : AppColors.ink),
      title: Text(
        label,
        style: TextStyle(color: selected ? AppColors.green : AppColors.ink, fontWeight: selected ? FontWeight.w800 : FontWeight.w500),
      ),
      selected: selected,
      selectedTileColor: AppColors.greenSoft,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        if (page == null) {
          Navigator.pop(context);
          return;
        }
        openAdminPage(context, page);
      },
    );
  }
}
