import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_images.dart';
import 'package:textiles/resources/app_text.dart';
import 'package:textiles/screens/user/my_orders_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/common.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = context.watch<StoreRepository>().lastOrderId ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              bottom: 0,
              child: _PhotoCrop(
                alignment: Alignment.bottomLeft,
                width: 150,
                height: 190,
              ),
            ),
            const Positioned(
              right: 0,
              bottom: 0,
              child: _PhotoCrop(
                alignment: Alignment.bottomRight,
                width: 110,
                height: 130,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
              child: Column(
                children: [
                  const SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: -22,
                          top: 0,
                          child: _PhotoCrop(
                            alignment: Alignment.topRight,
                            width: 230,
                            height: 250,
                          ),
                        ),
                        Align(
                          alignment: Alignment(-0.15, 0.05),
                          child: Image(
                            image: AssetImage(AppImages.orderCheck),
                            width: 188,
                            height: 188,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Order Placed\nSuccessfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Thank you for shopping with ${AppText.brand}.\nYour order has been placed and will be\ndelivered soon.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: Color(0xFF6E6E6E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Order ID: $orderId',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    label: 'Continue Shopping',
                    onPressed: () => selectTab(context, 0),
                  ),
                  const SizedBox(height: 12),
                  OutlineAction(
                    label: 'View Orders',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => const MyOrdersScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows one corner of the lifestyle photo so clothing peeks in
/// around the success message, matching the order-placed layout.
class _PhotoCrop extends StatelessWidget {
  const _PhotoCrop({
    required this.alignment,
    required this.width,
    required this.height,
  });

  final Alignment alignment;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: width,
        height: height,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) {
            return RadialGradient(
              center: alignment,
              radius: 1.15,
              colors: const [Colors.black, Colors.black, Colors.transparent],
              stops: const [0.2, 0.55, 1],
            ).createShader(bounds);
          },
          child: Image.asset(
            AppImages.lifestyle,
            fit: BoxFit.cover,
            alignment: alignment,
          ),
        ),
      ),
    );
  }
}
