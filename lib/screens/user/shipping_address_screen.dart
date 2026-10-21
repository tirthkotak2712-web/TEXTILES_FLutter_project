import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/payment_methods_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/common.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return Scaffold(
      appBar: const TextilesAppBar(title: 'Shipping Address', titleColor: AppColors.green, showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Where should we deliver?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          for (final address in store.addresses)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => store.selectAddress(address.id),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: AppStyles.card(selected: store.selectedAddressId == address.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${address.label} · ${address.name}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(address.lines),
                      Text(address.phone),
                    ],
                  ),
                ),
              ),
            ),
          PrimaryButton(
            label: 'Confirm Shipping Address',
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PaymentMethodsScreen())),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(index: 2),
    );
  }
}
