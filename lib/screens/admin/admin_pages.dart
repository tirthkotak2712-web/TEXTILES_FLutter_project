import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/format.dart';
import 'package:textiles/core/validators.dart';
import 'package:textiles/models/order.dart';
import 'package:textiles/models/product.dart';
import 'package:textiles/models/review.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_images.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/admin/admin_nav.dart';
import 'package:textiles/screens/user/change_password_screen.dart';
import 'package:textiles/widgets/common.dart';
import 'package:textiles/widgets/product_card.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final products = context.watch<StoreRepository>().products.where((product) {
      final needle = _query.trim().toLowerCase();
      return needle.isEmpty || product.name.toLowerCase().contains(needle);
    }).toList();
    return AdminPage(
      title: 'Products',
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined)),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search products..',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () => openAdminPage(context, AdminProductFormScreen(product: product)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        SizedBox(width: 110, height: 110, child: CatalogImage(image: product.image)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                              Text(Format.inr(product.price), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                              Text('Stock: ${product.stock}', style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: PrimaryButton(
              label: '+ Add Product',
              onPressed: () => openAdminPage(context, const AdminProductFormScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminProductFormScreen extends StatefulWidget {
  const AdminProductFormScreen({super.key, this.product});

  final Product? product;

  @override
  State<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends State<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _discount;
  late final TextEditingController _stock;
  late final TextEditingController _description;
  late String _category;
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _name = TextEditingController(text: product?.name ?? '');
    _price = TextEditingController(text: product == null ? '' : product.price.round().toString());
    _discount = TextEditingController(text: product?.compareAtPrice == null ? '' : (product!.compareAtPrice! - product.price).round().toString());
    _stock = TextEditingController(text: product?.stock.toString() ?? '');
    _description = TextEditingController(text: product?.description ?? '');
    _category = product?.category ?? 'shirts';
    _images = [if (product != null) product.image];
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _discount.dispose();
    _stock.dispose();
    _description.dispose();
    super.dispose();
  }

  void _pickImages() {
    final gallery = AppImages.gallery;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
          itemCount: gallery.length,
          itemBuilder: (_, index) {
            final image = gallery[index];
            return InkWell(
              onTap: () {
                setState(() {
                  if (_images.contains(image)) {
                    _images.remove(image);
                  } else if (_images.length < 5) {
                    _images.add(image);
                  }
                });
                Navigator.pop(sheetContext);
              },
              child: CatalogImage(image: image, radius: 8),
            );
          },
        );
      },
    );
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_images.isEmpty) {
      showAppMessage(context, 'Add at least one product image.');
      return;
    }
    context.read<StoreRepository>().saveProduct(
          id: widget.product?.id,
          name: _name.text.trim(),
          category: _category,
          price: double.parse(_price.text.trim()),
          discount: double.tryParse(_discount.text.trim()) ?? 0,
          stock: int.parse(_stock.text.trim()),
          description: _description.text.trim(),
          image: _images.first,
        );
    showAppMessage(context, widget.product == null ? 'Product added.' : 'Product updated.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<StoreRepository>().categories;
    return AdminPage(
      title: widget.product == null ? 'Add Product' : 'Update Product',
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickImages,
                    child: Container(
                      height: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 36),
                          SizedBox(height: 6),
                          Text('Add Images', style: TextStyle(fontWeight: FontWeight.w800)),
                          Text('up to 5 images', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    for (final image in _images.take(2))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(width: 72, height: 72, child: CatalogImage(image: image, radius: 8)),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Product Name', style: TextStyle(fontWeight: FontWeight.w800)),
            TextFormField(
              controller: _name,
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter the product name.' : null,
              decoration: AppStyles.field(hint: 'Enter product name'),
            ),
            const SizedBox(height: 12),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w800)),
            DropdownButtonFormField<String>(
              initialValue: categories.any((item) => item.id == _category) ? _category : categories.first.id,
              decoration: AppStyles.field(hint: 'Category'),
              items: [
                for (final category in categories)
                  DropdownMenuItem(value: category.id, child: Text(category.name)),
              ],
              onChanged: (value) => setState(() => _category = value ?? _category),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _moneyField('Price', _price)),
                const SizedBox(width: 12),
                Expanded(child: _moneyField('Discount Price', _discount, requiredField: false)),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Stock Quantity', style: TextStyle(fontWeight: FontWeight.w800)),
            TextFormField(
              controller: _stock,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => RegExp(r'^[0-9]+$').hasMatch(value?.trim() ?? '') ? null : 'Enter a whole number.',
              decoration: AppStyles.field(hint: '120'),
            ),
            const SizedBox(height: 12),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.w800)),
            TextFormField(
              controller: _description,
              validator: (value) => (value == null || value.trim().length < 8) ? 'Enter a short description.' : null,
              decoration: AppStyles.field(hint: 'Premium quality shirt for man.'),
            ),
            const SizedBox(height: 18),
            PrimaryButton(label: widget.product == null ? 'Add Product' : 'Update Product', onPressed: _save),
          ],
        ),
      ),
    );
  }

  Widget _moneyField(String label, TextEditingController controller, {bool requiredField = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          validator: (value) {
            final text = value?.trim() ?? '';
            if (!requiredField && text.isEmpty) return null;
            if (!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(text)) return 'Enter a valid amount.';
            return null;
          },
          decoration: AppStyles.field(hint: '0', prefix: const Text('₹ ')),
        ),
      ],
    );
  }
}

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final shown = store.categories.where((category) => category.id != 'winter' && category.id != 'shorts' && category.id != 'jackets').toList();
    return AdminPage(
      title: 'Category',
      actions: [
        TextButton(
          onPressed: () => _add(context),
          child: const Text('+ Add', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800)),
        ),
      ],
      body: ListView.separated(
        itemCount: shown.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final category = shown[index];
          return ListTile(
            leading: Icon(category.icon, color: AppColors.green),
            title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('${store.countForCategory(category.id)} Products', style: const TextStyle(color: AppColors.muted)),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add category'),
        content: TextFormField(
          controller: controller,
          decoration: AppStyles.field(hint: 'Category name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final value = controller.text.trim();
              if (!AppValidators.namePattern.hasMatch(value)) return;
              Navigator.pop(dialogContext, value);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name != null && context.mounted) context.read<StoreRepository>().addCategory(name);
  }
}

class AdminInventoryScreen extends StatefulWidget {
  const AdminInventoryScreen({super.key, this.lowOnly = false});

  final bool lowOnly;

  @override
  State<AdminInventoryScreen> createState() => _AdminInventoryScreenState();
}

class _AdminInventoryScreenState extends State<AdminInventoryScreen> {
  late bool _lowOnly = widget.lowOnly;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final products = store.products.where((product) {
      if (_lowOnly && !product.isLowStock) return false;
      final needle = _query.trim().toLowerCase();
      return needle.isEmpty || product.name.toLowerCase().contains(needle);
    }).toList();
    return AdminPage(
      title: 'Inventory',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search products..',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                for (final product in products)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        SizedBox(width: 90, height: 100, child: CatalogImage(image: product.image)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                              Text('Stock: ${product.stock}', style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w800)),
                              Text('Low: ${product.lowStockAt}', style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: PrimaryButton(
              label: 'Low Stock Items (${store.lowStockProducts.length})',
              onPressed: () => setState(() => _lowOnly = !_lowOnly),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key, this.initialFilter = 'All'});

  final String initialFilter;

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late String _filter = widget.initialFilter;

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<StoreRepository>().orders.where((order) {
      return switch (_filter) {
        'Pending' => order.status == OrderStatus.pending,
        'Shipped' => order.status == OrderStatus.shipped,
        'Delivered' => order.status == OrderStatus.delivered,
        'Cancel' => order.status == OrderStatus.cancelled,
        _ => true,
      };
    }).toList();
    return AdminPage(
      title: 'Orders',
      body: Column(
        children: [
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final label in ['All', 'Pending', 'Shipped', 'Delivered', 'Cancel'])
                  GestureDetector(
                    onTap: () => setState(() => _filter = label),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: _filter == label ? AppColors.green : Colors.transparent, width: 3)),
                      ),
                      alignment: Alignment.center,
                      child: Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: _filter == label ? AppColors.ink : AppColors.muted)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  onTap: () => openAdminPage(context, AdminOrderDetailsScreen(orderId: order.id)),
                  title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${order.customerName}\n${Format.inr(order.lines.first.price)}'),
                  isThreeLine: true,
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Format.date(order.placedAt)),
                      Text(Format.inr(order.total), style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(
                        order.status == OrderStatus.cancelled ? 'Cancled' : order.status.label,
                        style: TextStyle(color: statusColor(order.status.label), fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminOrderDetailsScreen extends StatelessWidget {
  const AdminOrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final order = store.orderById(orderId);
    if (order == null) return const AdminPage(title: 'Order Details', body: Center(child: Text('Order not found')));
    final customer = store.customerById(order.customerId);
    return AdminPage(
      title: 'Order Details',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _line('Order ID', order.id),
          _line('Date', Format.dateTime(order.placedAt)),
          _line('Customer', '${order.customerName}\n${customer?.phone ?? ''}'),
          _line('Payment Method', order.paymentMethod),
          _line('Payment Status', order.paymentStatus, valueColor: AppColors.green),
          const Divider(),
          const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(order.address),
          const SizedBox(height: 12),
          Text('Items (${order.lines.length})', style: const TextStyle(fontWeight: FontWeight.w800)),
          for (final line in order.lines)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(width: 56, height: 56, child: CatalogImage(image: line.image, radius: 8)),
              title: Text(line.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              trailing: Text('${Format.inr(line.price)} × ${line.quantity}'),
            ),
          _line('Total Amount', Format.inr(order.total)),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Update Status',
            onPressed: () => openAdminPage(context, AdminOrderStatusScreen(orderId: order.id)),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
          Text(value, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }
}

class AdminOrderStatusScreen extends StatelessWidget {
  const AdminOrderStatusScreen({super.key, required this.orderId});

  final String orderId;

  static const _steps = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.packed,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final order = store.orderById(orderId);
    if (order == null) return const AdminPage(title: 'Update Order Status', body: SizedBox.shrink());
    final currentIndex = _steps.indexOf(order.status);
    return AdminPage(
      title: 'Update Order Status',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Order ID', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          Text(order.id, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 18),
          for (var index = 0; index < _steps.length; index++)
            _step(
              label: _steps[index].label,
              time: order.timeline[_steps[index]],
              reached: currentIndex >= 0 && index <= currentIndex,
              last: index == _steps.length - 1,
            ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Update Status',
            onPressed: () {
              if (currentIndex < 0 || currentIndex >= _steps.length - 1) {
                showAppMessage(context, 'This order cannot move further.');
                return;
              }
              store.updateOrderStatus(order.id, _steps[currentIndex + 1]);
            },
          ),
        ],
      ),
    );
  }

  Widget _step({required String label, required DateTime? time, required bool reached, required bool last}) {
    final color = reached ? AppColors.green : const Color(0xFFD0D0D0);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2), color: Colors.white),
            ),
            if (!last) Container(width: 2, height: 46, color: color),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: reached ? AppColors.ink : AppColors.muted)),
            if (time != null) Text(Format.dateTime(time), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<StoreRepository>().customers.where((customer) {
      final needle = _query.trim().toLowerCase();
      return needle.isEmpty || customer.name.toLowerCase().contains(needle) || customer.email.toLowerCase().contains(needle);
    }).toList();
    return AdminPage(
      title: 'Customers',
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search Customers.....',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: customers.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  onTap: () => openAdminPage(context, AdminCustomerProfileScreen(customerId: customer.id)),
                  leading: const CircleAvatar(backgroundColor: Color(0xFFE6E6E6), child: Icon(Icons.person, color: Colors.white)),
                  title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${customer.email}\n${customer.phone}'),
                  isThreeLine: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminCustomerProfileScreen extends StatelessWidget {
  const AdminCustomerProfileScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final customer = store.customerById(customerId);
    if (customer == null) return const AdminPage(title: 'Customer Profile', body: Center(child: Text('Customer not found')));
    final orders = store.ordersForCustomer(customer.id);
    final spend = orders.fold<double>(0, (sum, order) => sum + order.total);
    return AdminPage(
      title: 'Customer Profile',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 36, backgroundColor: Color(0xFFE6E6E6), child: Icon(Icons.person, color: Colors.white, size: 36)),
          const SizedBox(height: 8),
          Text(customer.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          Text(customer.email, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
          Text(customer.phone, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
          Text('joined on ${Format.date(customer.joinedOn)}', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 16),
          Row(
            children: [
              _box('Orders', '${orders.length}'),
              _box('TotalSpend', Format.inr(spend)),
              _box('Wishlist', customer.id == 'yash' ? '5' : '0'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Recent Orders', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          for (final order in orders.take(3))
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: AppStyles.card(),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.id, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(Format.date(order.placedAt), style: const TextStyle(color: AppColors.muted)),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Format.inr(order.total), style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(order.status.label, style: TextStyle(color: statusColor(order.status.label), fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'View All Orders',
            onPressed: () => openAdminPage(context, const AdminOrdersScreen()),
          ),
        ],
      ),
    );
  }

  Widget _box(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: AppStyles.card(),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class AdminReviewsScreen extends StatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  State<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends State<AdminReviewsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final reviews = store.reviews.where((review) {
      return switch (_filter) {
        'Pending' => review.status == ReviewStatus.pending,
        'Approved' => review.status == ReviewStatus.approved,
        'Rejected' => review.status == ReviewStatus.rejected,
        _ => true,
      };
    }).toList();
    return AdminPage(
      title: 'Reviews',
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                for (final label in ['All', 'Pending', 'Approved', 'Rejected'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _filter == label,
                      selectedColor: AppColors.green,
                      labelStyle: TextStyle(color: _filter == label ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
                      onSelected: (_) => setState(() => _filter = label),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  leading: const CircleAvatar(backgroundColor: Color(0xFFE6E6E6)),
                  title: Text(review.productName, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.customerName),
                      Row(children: [for (var star = 0; star < review.stars; star++) const Icon(Icons.star, color: AppColors.star, size: 16)]),
                      Text(review.comment),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Format.date(review.date), style: const TextStyle(fontSize: 12)),
                      PopupMenuButton<ReviewStatus>(
                        onSelected: (status) => store.setReviewStatus(review.id, status),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: ReviewStatus.approved, child: Text('Approved')),
                          PopupMenuItem(value: ReviewStatus.pending, child: Text('Pending')),
                          PopupMenuItem(value: ReviewStatus.rejected, child: Text('Rejected')),
                        ],
                        child: Text(review.status.label, style: TextStyle(color: statusColor(review.status.label), fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminCouponsScreen extends StatelessWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return AdminPage(
      title: 'Coupons',
      actions: [
        TextButton(
          onPressed: () => _add(context),
          child: const Text('+Add Coupons', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800)),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final coupon in store.coupons)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                        Text(coupon.offerLabel),
                        Text('Min.order ${Format.inr(coupon.minOrder)}'),
                        Text('Valid till ${Format.date(coupon.validTill)}'),
                      ],
                    ),
                  ),
                  Switch(value: coupon.active, activeThumbColor: AppColors.green, onChanged: (value) => store.toggleCoupon(coupon.code, value)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final code = TextEditingController();
    final percent = TextEditingController();
    final minOrder = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add coupon'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: code, decoration: AppStyles.field(hint: 'Code')),
            const SizedBox(height: 8),
            TextField(controller: percent, keyboardType: TextInputType.number, decoration: AppStyles.field(hint: 'Percent')),
            const SizedBox(height: 8),
            TextField(controller: minOrder, keyboardType: TextInputType.number, decoration: AppStyles.field(hint: 'Minimum order')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Add')),
        ],
      ),
    );
    if (saved != true || !context.mounted) return;
    if (!AppValidators.promoPattern.hasMatch(code.text.trim())) {
      showAppMessage(context, 'Code must start with a letter and use 4–15 letters or numbers.');
      return;
    }
    final percentValue = int.tryParse(percent.text.trim());
    final minValue = double.tryParse(minOrder.text.trim());
    if (percentValue == null || minValue == null) {
      showAppMessage(context, 'Enter a percent and a minimum order.');
      return;
    }
    context.read<StoreRepository>().addCoupon(code: code.text.trim(), percent: percentValue, minOrder: minValue, validTill: DateTime(2027, 12, 31));
  }
}

class AdminBannersScreen extends StatelessWidget {
  const AdminBannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return AdminPage(
      title: 'Banners',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final banner in store.banners)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: AppStyles.card(),
              child: Row(
                children: [
                  SizedBox(width: 88, height: 64, child: CatalogImage(image: banner.image, radius: 8)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(banner.title, style: const TextStyle(fontWeight: FontWeight.w800))),
                  Switch(value: banner.active, activeThumbColor: AppColors.green, onChanged: (value) => store.toggleBanner(banner.id, value)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AdminPaymentsScreen extends StatefulWidget {
  const AdminPaymentsScreen({super.key});

  @override
  State<AdminPaymentsScreen> createState() => _AdminPaymentsScreenState();
}

class _AdminPaymentsScreenState extends State<AdminPaymentsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final payments = context.watch<StoreRepository>().payments.where((payment) {
      final needle = _query.trim().toLowerCase();
      return needle.isEmpty || payment.customerName.toLowerCase().contains(needle) || payment.id.toLowerCase().contains(needle);
    }).toList();
    return AdminPage(
      title: 'Payments',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search transactions..',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: payments.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final payment = payments[index];
                final success = payment.status.toLowerCase() == 'success';
                return ListTile(
                  title: Text(payment.id, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${payment.customerName}\n${Format.inr(payment.amount)}'),
                  isThreeLine: true,
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Format.date(payment.date)),
                      Text(payment.status, style: TextStyle(color: success ? AppColors.green : AppColors.danger, fontWeight: FontWeight.w800)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final revenue = store.orders.fold<double>(0, (sum, order) => sum + order.total);
    return AdminPage(
      title: 'Reports',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card('Orders in this device', '${store.orders.length}'),
          _card('Revenue from these orders', Format.inr(revenue)),
          _card('Customers', '${store.customers.length}'),
          _card('Live products', '${store.products.length}'),
          _card('Low stock', '${store.lowStockProducts.length}'),
        ],
      ),
    );
  }

  Widget _card(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _message = TextEditingController();
  String _audience = 'All Users';
  DateTime? _sendAt;

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: DateTime.now());
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null || !mounted) return;
    setState(() => _sendAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  void _send() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_sendAt == null) {
      showAppMessage(context, 'Select a date and time.');
      return;
    }
    context.read<StoreRepository>().sendNotification(audience: _audience, title: _title.text.trim(), message: _message.text.trim(), sendAt: _sendAt!);
    showAppMessage(context, 'Notification scheduled.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: 'Send Notification',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('To:', style: TextStyle(fontWeight: FontWeight.w800)),
            DropdownButtonFormField<String>(
              initialValue: _audience,
              decoration: AppStyles.field(hint: 'Audience'),
              items: const [
                DropdownMenuItem(value: 'All Users', child: Text('All Users')),
                DropdownMenuItem(value: 'Customers', child: Text('Customers')),
              ],
              onChanged: (value) => setState(() => _audience = value ?? _audience),
            ),
            const SizedBox(height: 12),
            const Text('Title', style: TextStyle(fontWeight: FontWeight.w800)),
            TextFormField(
              controller: _title,
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter a title.' : null,
              decoration: AppStyles.field(hint: 'Enter Title'),
            ),
            const SizedBox(height: 12),
            const Text('Message', style: TextStyle(fontWeight: FontWeight.w800)),
            TextFormField(
              controller: _message,
              validator: (value) => (value == null || value.trim().length < 4) ? 'Enter a message.' : null,
              decoration: AppStyles.field(hint: 'Enter Message'),
            ),
            const SizedBox(height: 12),
            const Text('Send At', style: TextStyle(fontWeight: FontWeight.w800)),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: AppStyles.field(hint: 'Select Date & Time', suffix: const Icon(Icons.calendar_month_outlined)),
                child: Text(_sendAt == null ? 'Select Date & Time' : Format.dateTime(_sendAt!), style: TextStyle(color: _sendAt == null ? AppColors.muted : AppColors.ink)),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Send Notification', onPressed: _send),
          ],
        ),
      ),
    );
  }
}

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return AdminPage(
      title: 'Settings',
      body: ListView(
        children: [
          _tile(context, Icons.storefront_outlined, 'Store Information', 'TEXTILES'),
          _tile(context, Icons.local_shipping_outlined, 'Shipping Settings', Format.inr(store.shippingFee), onTap: () => _editNumber(context, 'Shipping fee', store.shippingFee, (value) => store.updateStoreSettings(shippingFee: value))),
          _tile(context, Icons.receipt_outlined, 'Tax Settings', '${(store.taxRate * 100).round()}%', onTap: () => _editNumber(context, 'Tax percent', store.taxRate * 100, (value) => store.updateStoreSettings(taxRate: value / 100))),
          _tile(context, Icons.account_balance_outlined, 'Payment Settings', store.paymentMethod),
          _tile(context, Icons.policy_outlined, 'Return Policy', '7 day returns'),
          _tile(context, Icons.currency_rupee, 'Currency', store.currency),
          _tile(context, Icons.settings_outlined, 'General Settings', 'Change password', onTap: () => openAdminPage(context, const ChangePasswordScreen())),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String trailing, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: const TextStyle(color: AppColors.muted)),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  Future<void> _editNumber(BuildContext context, String label, double current, ValueChanged<double> onSave) async {
    final controller = TextEditingController(text: current.round().toString());
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(label),
        content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: AppStyles.field(hint: label)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Save')),
        ],
      ),
    );
    if (saved != true || !context.mounted) return;
    final value = double.tryParse(controller.text.trim());
    if (value == null) {
      showAppMessage(context, 'Enter a number.');
      return;
    }
    onSave(value);
  }
}