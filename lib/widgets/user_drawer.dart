import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/login_screen.dart';
import 'package:textiles/screens/user/my_orders_screen.dart';
import 'package:textiles/screens/user/wishlist_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/common.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.78,
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.green,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFD7EBD9),
                  child: Icon(Icons.person, size: 40, color: AppColors.greenDark),
                ),
                const SizedBox(height: 14),
                Text(
                  store.sessionName,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                ),
                Text(store.sessionEmail, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          _tile(Icons.home_outlined, 'Shop', () {
            Navigator.pop(context);
            selectTab(context, 0);
          }),
          _tile(Icons.inventory_2_outlined, 'My Orders', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MyOrdersScreen()));
          }),
          _tile(Icons.favorite_border, 'Wishlist', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const WishlistScreen()));
          }),
          _tile(Icons.category_outlined, 'Categories', () {
            Navigator.pop(context);
            selectTab(context, 1);
          }),
          _tile(Icons.notifications_none, 'Notifications', () {
            Navigator.pop(context);
            showAppMessage(context, 'No new notifications.');
          }),
          _tile(Icons.help_outline, 'Help & Support', () {
            Navigator.pop(context);
            showAppMessage(context, 'Write to hello@textiles.store');
          }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: Color(0xFFF3C7C7)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => confirmLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.green),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}

Future<void> confirmLogout(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E4),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.logout, color: AppColors.danger, size: 42),
              ),
              const SizedBox(height: 22),
              const Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'Yes, Logout',
                color: AppColors.danger,
                onPressed: () {
                  dialogContext.read<StoreRepository>().logout();
                  Navigator.of(dialogContext).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
              OutlineAction(
                label: 'Cancel',
                color: AppColors.ink,
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ],
          ),
        ),
      );
    },
  );
}
