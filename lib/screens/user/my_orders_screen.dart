import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/format.dart';
import 'package:textiles/models/order.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/common.dart';
import 'package:textiles/widgets/product_card.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<StoreRepository>().myOrders;
    return Scaffold(
      appBar: const TextilesAppBar(title: 'My Order', titleColor: AppColors.green, showBack: true),
      body: orders.isEmpty
          ? const Center(child: Text('You have not placed an order yet.'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = orders[index];
                final line = order.lines.first;
                return ListTile(
                  leading: SizedBox(width: 64, height: 72, child: CatalogImage(image: line.image)),
                  title: Text(line.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${order.id}\n${Format.date(order.placedAt)}'),
                  isThreeLine: true,
                  trailing: Text(
                    order.status == OrderStatus.pending ? 'Processing' : order.status.label,
                    style: TextStyle(color: statusColor(order.status.label), fontWeight: FontWeight.w800),
                  ),
                );
              },
            ),
      bottomNavigationBar: const AppBottomNav(index: 3),
    );
  }
}
