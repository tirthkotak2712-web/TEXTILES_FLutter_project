import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/change_password_screen.dart';
import 'package:textiles/screens/user/my_orders_screen.dart';
import 'package:textiles/screens/user/wishlist_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/user_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: const TextilesAppBar(title: 'Profile', titleColor: AppColors.green, showMenu: true, showCart: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 42, backgroundColor: AppColors.greenSoft, child: Icon(Icons.person, size: 48, color: AppColors.greenDark)),
          const SizedBox(height: 12),
          Text(store.sessionName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          Text(store.sessionEmail, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('My Orders'),
            trailing: Text('${store.activeOrderCount}'),
            onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MyOrdersScreen())),
          ),
          ListTile(
            title: const Text('Wishlist'),
            trailing: Text('${store.wishlistIds.length}'),
            onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const WishlistScreen())),
          ),
          ListTile(
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ChangePasswordScreen())),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => confirmLogout(context),
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: const Text('Logout', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(index: 3),
    );
  }
}
