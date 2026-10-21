import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/format.dart';
import 'package:textiles/core/validators.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/shipping_address_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/common.dart';
import 'package:textiles/widgets/product_card.dart';
import 'package:textiles/widgets/user_drawer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _apply() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final error = context.read<StoreRepository>().applyCoupon(_code.text);
    showAppMessage(context, error ?? '${_code.text.trim()} applied');
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: const TextilesAppBar(title: 'Shopping Cart', titleColor: AppColors.green, showMenu: true, showCart: true),
      body: store.cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              children: [
                for (final item in store.cart)
                  Builder(builder: (context) {
                    final product = store.productById(item.productId);
                    if (product == null) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: AppStyles.card(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 72, height: 72, child: CatalogImage(image: product.image, radius: 10)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => store.removeFromCart(product.id),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                                if (product.subtitle.isNotEmpty)
                                  Text(product.subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(Format.inr(product.price), style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w800, fontSize: 16)),
                                    const Spacer(),
                                    QtyStepper(quantity: item.quantity, onChanged: (value) => store.setQuantity(product.id, value)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: _code,
                    textCapitalization: TextCapitalization.characters,
                    validator: AppValidators.promo,
                    decoration: AppStyles.field(
                      hint: 'Promo code',
                      prefix: const Icon(Icons.local_offer_outlined, color: AppColors.green),
                      suffix: TextButton(
                        onPressed: _apply,
                        child: const Text('APPLY', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _row('Subtotal', Format.inr(store.cartSubtotal)),
                      _row('Shipping', Format.inr(store.cartShipping)),
                      _row('Estimated Tax', Format.inr(store.cartTax)),
                      const Divider(height: 22),
                      _row('Total', Format.inr(store.cartTotal), emphasize: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Proceed to Checkout  →',
                  onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ShippingAddressScreen())),
                ),
              ],
            ),
      bottomNavigationBar: const AppBottomNav(index: 2),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    final style = TextStyle(fontWeight: emphasize ? FontWeight.w900 : FontWeight.w600, fontSize: emphasize ? 18 : 15);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style.copyWith(color: emphasize ? AppColors.green : AppColors.ink)),
        ],
      ),
    );
  }
}
