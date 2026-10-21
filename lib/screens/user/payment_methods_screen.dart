import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/format.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/order_success_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/common.dart';
import 'package:textiles/widgets/user_drawer.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const _methods = [
    _PayMethod(
      title: 'Credit / Debit Card',
      subtitle: 'Visa, MasterCard, RuPay',
      icon: _CardGlyph(),
    ),
    _PayMethod(
      title: 'UPI',
      subtitle: 'Google Pay, PhonePe, Paytm',
      icon: _UpiGlyph(),
    ),
    _PayMethod(
      title: 'Net banking',
      subtitle: 'All major banks',
      icon: _BankGlyph(),
    ),
    _PayMethod(
      title: 'Cash on Delivery',
      subtitle: 'Pay when you receive',
      icon: _CashGlyph(),
    ),
    _PayMethod(
      title: 'Wallet',
      subtitle: 'Pay using wallet balance',
      icon: _WalletGlyph(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return Scaffold(
      drawer: const UserDrawer(),
      backgroundColor: Colors.white,
      appBar: const _PaymentAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => goBack(context),
              icon: const Icon(Icons.arrow_back, color: AppColors.ink),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              children: [
                for (final method in _methods)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MethodCard(
                      method: method,
                      selected: store.paymentMethod == method.title,
                      onTap: () => store.selectPayment(method.title),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Format.inr(store.cartTotal),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 148,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      final error = store.placeOrder();
                      if (error != null) {
                        showAppMessage(context, error);
                        return;
                      }
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const OrderSuccessScreen(),
                        ),
                        (route) => route.isFirst,
                      );
                    },
                    child: const Text('Pay Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(index: 0),
    );
  }
}

class _PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PaymentAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(79);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 78,
      backgroundColor: const Color(0xFFFBF9F6),
      surfaceTintColor: const Color(0xFFFBF9F6),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.menu, color: AppColors.ink, size: 28),
      ),
      centerTitle: true,
      title: const Text(
        'Payment\nMethods',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF146C32),
          fontWeight: FontWeight.w800,
          fontSize: 22,
          height: 1.15,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => selectTab(context, 2),
          icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.ink, size: 26),
        ),
        const SizedBox(width: 4),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Color(0xFFE4E4E4)),
      ),
    );
  }
}

class _PayMethod {
  const _PayMethod({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Widget icon;
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final _PayMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.green : const Color(0xFFD5D5D5),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                SizedBox(width: 58, height: 42, child: Center(child: method.icon)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        method.subtitle,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF8A8A8A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardGlyph extends StatelessWidget {
  const _CardGlyph();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 6,
            top: 8,
            child: Container(
              width: 8,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 6,
            top: 9,
            child: Container(height: 2, color: Colors.white),
          ),
          Positioned(
            left: 18,
            right: 10,
            top: 14,
            child: Container(height: 2, color: const Color(0xFFBDBDBD)),
          ),
        ],
      ),
    );
  }
}

class _UpiGlyph extends StatelessWidget {
  const _UpiGlyph();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'UPI',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            height: 1,
            letterSpacing: -0.4,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          width: 34,
          height: 4,
          child: Row(
            children: const [
              Expanded(child: ColoredBox(color: Color(0xFFFF7A00))),
              Expanded(child: ColoredBox(color: Color(0xFF2E7D32))),
            ],
          ),
        ),
      ],
    );
  }
}

class _BankGlyph extends StatelessWidget {
  const _BankGlyph();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.account_balance_outlined, size: 34, color: Colors.black);
  }
}

class _CashGlyph extends StatelessWidget {
  const _CashGlyph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 32,
      child: Stack(
        children: [
          Positioned(left: 8, top: 0, child: _note()),
          Positioned(left: 0, top: 7, child: _note(front: true)),
        ],
      ),
    );
  }

  Widget _note({bool front = false}) {
    return Container(
      width: 32,
      height: 22,
      decoration: BoxDecoration(
        color: front ? Colors.white : const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.black, width: 1.6),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1.4),
        ),
      ),
    );
  }
}

class _WalletGlyph extends StatelessWidget {
  const _WalletGlyph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 30,
      child: Stack(
        children: [
          Positioned(
            left: 2,
            top: 6,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 8,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            right: 4,
            top: 14,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
