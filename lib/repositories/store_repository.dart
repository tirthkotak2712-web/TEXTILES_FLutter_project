import 'package:flutter/material.dart';
import 'package:textiles/models/address.dart';
import 'package:textiles/models/cart_item.dart';
import 'package:textiles/models/category.dart';
import 'package:textiles/models/coupon.dart';
import 'package:textiles/models/customer.dart';
import 'package:textiles/models/order.dart';
import 'package:textiles/models/payment_record.dart';
import 'package:textiles/models/product.dart';
import 'package:textiles/models/review.dart';
import 'package:textiles/models/store_banner.dart';
import 'package:textiles/core/validators.dart';
import 'package:textiles/resources/app_images.dart';
import 'package:textiles/resources/app_text.dart';

class StoreNotification {
  const StoreNotification({
    required this.id,
    required this.audience,
    required this.title,
    required this.message,
    required this.sendAt,
  });

  final String id;
  final String audience;
  final String title;
  final String message;
  final DateTime sendAt;
}

class StoreRepository extends ChangeNotifier {
  StoreRepository() {
    _seed();
  }

  final List<Product> _products = [];
  final List<ShopOrder> _orders = [];
  final List<Customer> _customers = [];
  final List<ProductReview> _reviews = [];
  final List<Coupon> _coupons = [];
  final List<Address> _addresses = [];
  final List<PaymentRecord> _payments = [];
  final List<StoreBanner> _banners = [];
  final List<CartItem> _cart = [];
  final List<String> _wishlist = [];
  final List<String> _recentSearches = ['T-Shirts', 'Shirts', 'Pants', 'Short', 'Winter'];
  final List<StoreNotification> _notifications = [];
  final Map<String, String> _passwords = {
    AppText.demoShopEmail: AppText.demoShopPassword,
    AppText.demoAdminEmail: AppText.demoAdminPassword,
  };

  String? _sessionName;
  String? _sessionEmail;
  String? _sessionPhone;
  bool _isAdmin = false;
  String? _customerId;
  int _tabIndex = 0;
  String? _appliedCoupon;
  String? _selectedAddressId;
  String _paymentMethod = 'UPI';
  String? _lastOrderId;
  double _shippingFee = 199;
  double _taxRate = 0.05;
  String _currency = 'INR (₹)';

  static const headlineRevenue = 245890.0;
  static const headlineOrders = 1248;
  static const headlineCustomers = 2356;
  static const headlineProducts = 356;
  static const headlinePending = 84;

  List<Product> get products => List.unmodifiable(_products);
  List<ShopOrder> get orders => List.unmodifiable(_orders);
  List<Customer> get customers => List.unmodifiable(_customers);
  List<ProductReview> get reviews => List.unmodifiable(_reviews);
  List<Coupon> get coupons => List.unmodifiable(_coupons);
  List<Address> get addresses => List.unmodifiable(_addresses);
  List<PaymentRecord> get payments => List.unmodifiable(_payments);
  List<StoreBanner> get banners => List.unmodifiable(_banners);
  List<CartItem> get cart => List.unmodifiable(_cart);
  List<String> get wishlistIds => List.unmodifiable(_wishlist);
  List<String> get recentSearches => List.unmodifiable(_recentSearches);
  List<StoreNotification> get notifications => List.unmodifiable(_notifications);

  bool get isAdmin => _isAdmin;
  String get sessionName => _sessionName ?? 'Guest';
  String get sessionEmail => _sessionEmail ?? '';
  String get sessionPhone => _sessionPhone ?? '';
  int get tabIndex => _tabIndex;
  String? get appliedCouponCode => _appliedCoupon;
  String? get selectedAddressId => _selectedAddressId;
  String get paymentMethod => _paymentMethod;
  String? get lastOrderId => _lastOrderId;
  double get shippingFee => _shippingFee;
  double get taxRate => _taxRate;
  String get currency => _currency;

  final List<StoreCategory> _categories = [
    const StoreCategory(id: 'tshirts', name: 'T-Shirts', icon: Icons.checkroom_outlined, image: AppImages.categoryTshirts, onHome: true, onGrid: true),
    const StoreCategory(id: 'shirts', name: 'Shirts', icon: Icons.dry_cleaning_outlined, image: AppImages.categoryShirts, onHome: true, onGrid: true),
    const StoreCategory(id: 'jeans', name: 'Jeans', icon: Icons.straighten, onHome: true),
    const StoreCategory(id: 'pants', name: 'Pants', icon: Icons.straighten, image: AppImages.categoryPants, onGrid: true),
    const StoreCategory(id: 'shorts', name: 'Shorts', icon: Icons.short_text, image: AppImages.categoryShort, onGrid: true),
    const StoreCategory(id: 'winter', name: 'Winter', icon: Icons.ac_unit_outlined, image: AppImages.categoryWinter, onGrid: true),
    const StoreCategory(id: 'hoodies', name: 'Hoodies', icon: Icons.checkroom),
    const StoreCategory(id: 'jackets', name: 'Jackets', icon: Icons.checkroom),
    const StoreCategory(id: 'blazers', name: 'Blazer', icon: Icons.business_center_outlined),
    const StoreCategory(id: 'accessories', name: 'Accessories', icon: Icons.shopping_bag_outlined),
  ];

  List<StoreCategory> get categories => List.unmodifiable(_categories);

  void addCategory(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final id = trimmed.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
    if (_categories.any((category) => category.id == id)) return;
    _categories.add(StoreCategory(id: id, name: trimmed, icon: Icons.checkroom_outlined, onGrid: true));
    notifyListeners();
  }

  Product? productById(String id) {
    for (final product in _products) {
      if (product.id == id) return product;
    }
    return null;
  }

  ShopOrder? orderById(String id) {
    for (final order in _orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  Customer? customerById(String id) {
    for (final customer in _customers) {
      if (customer.id == id) return customer;
    }
    return null;
  }

  Address? get selectedAddress {
    for (final address in _addresses) {
      if (address.id == _selectedAddressId) return address;
    }
    return _addresses.where((address) => address.isDefault).firstOrNull ??
        (_addresses.isEmpty ? null : _addresses.first);
  }

  List<Product> productsForCategory(String categoryId) {
    if (categoryId == 'new') return _products.where((product) => product.isNew).toList();
    if (categoryId == 'winter') {
      return _products.where((product) => product.category == 'hoodies' || product.category == 'jackets').toList();
    }
    return _products.where((product) => product.category == categoryId).toList();
  }

  int countForCategory(String categoryId) => productsForCategory(categoryId).length;

  List<Product> get wishlistProducts =>
      _wishlist.map(productById).whereType<Product>().toList(growable: false);

  List<Product> get newArrivals => _products.where((product) => product.isNew).toList();

  List<Product> get bestSellers {
    final ranked = [..._products]..sort((a, b) => b.weeklySales.compareTo(a.weeklySales));
    return ranked.where((product) => product.weeklySales > 0).take(2).toList();
  }

  List<Product> get lowStockProducts => _products.where((product) => product.isLowStock).toList();

  List<ShopOrder> ordersForCustomer(String customerId) =>
      _orders.where((order) => order.customerId == customerId).toList(growable: false);

  List<ShopOrder> get myOrders => _customerId == null ? const [] : ordersForCustomer(_customerId!);

  int get activeOrderCount => myOrders
      .where((order) => order.status != OrderStatus.delivered && order.status != OrderStatus.cancelled)
      .length;

  double get cartSubtotal {
    var sum = 0.0;
    for (final item in _cart) {
      final product = productById(item.productId);
      if (product != null) sum += product.price * item.quantity;
    }
    return sum;
  }

  Coupon? get appliedCoupon {
    final code = _appliedCoupon;
    if (code == null) return null;
    for (final coupon in _coupons) {
      if (coupon.code.toLowerCase() == code.toLowerCase()) return coupon;
    }
    return null;
  }

  double get discountAmount {
    final coupon = appliedCoupon;
    if (coupon == null || !coupon.active || cartSubtotal < coupon.minOrder) return 0;
    return cartSubtotal * coupon.percent / 100;
  }

  double get cartShipping {
    final coupon = appliedCoupon;
    if (coupon != null && coupon.freeShipping && cartSubtotal >= coupon.minOrder) return 0;
    return _cart.isEmpty ? 0 : _shippingFee;
  }

  double get cartTax => ((cartSubtotal - discountAmount) * _taxRate).floorToDouble();

  double get cartTotal => (cartSubtotal - discountAmount) + cartShipping + cartTax;

  void setTab(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  String? login({required String email, required String password}) {
    final trimmed = email.trim().toLowerCase();
    if (trimmed.isEmpty || password.isEmpty) return 'Enter your email and password.';
    if (trimmed == AppText.demoAdminEmail && password == _passwords[AppText.demoAdminEmail]) {
      _signIn(name: 'Admin', email: AppText.demoAdminEmail, phone: '', admin: true, customerId: null);
      return null;
    }
    if (_passwords[trimmed] == password) {
      final known = _customers.where((customer) => customer.email.toLowerCase() == trimmed);
      if (known.isNotEmpty) {
        final customer = known.first;
        _signIn(name: customer.name, email: customer.email, phone: customer.phone, admin: false, customerId: customer.id);
        return null;
      }
    }
    return 'Those details do not match a TEXTILES account.';
  }

  void loginAsAdmin() {
    _signIn(name: 'Admin', email: AppText.demoAdminEmail, phone: '', admin: true, customerId: null);
  }

  String? signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirm,
  }) {
    final nameError = AppValidators.name(name);
    if (nameError != null) return nameError;
    final emailError = AppValidators.email(email);
    if (emailError != null) return emailError;
    final phoneError = AppValidators.phone(phone);
    if (phoneError != null) return phoneError;
    final passwordError = AppValidators.password(password);
    if (passwordError != null) return passwordError;
    if (password != confirm) return 'Passwords do not match.';
    final key = email.trim().toLowerCase();
    if (_passwords.containsKey(key)) return 'An account with this email already exists.';
    final id = 'c${DateTime.now().millisecondsSinceEpoch}';
    _customers.insert(0, Customer(id: id, name: name.trim(), email: email.trim(), phone: phone.trim(), joinedOn: DateTime.now()));
    _passwords[key] = password;
    _signIn(name: name.trim(), email: email.trim(), phone: phone.trim(), admin: false, customerId: id);
    return null;
  }

  void _signIn({
    required String name,
    required String email,
    required bool admin,
    required String? customerId,
    required String phone,
  }) {
    _sessionName = name;
    _sessionEmail = email;
    _sessionPhone = phone;
    _isAdmin = admin;
    _customerId = customerId;
    _tabIndex = 0;
    notifyListeners();
  }

  void logout() {
    _sessionName = null;
    _sessionEmail = null;
    _sessionPhone = null;
    _isAdmin = false;
    _customerId = null;
    _appliedCoupon = null;
    notifyListeners();
  }

  String? changePassword({required String current, required String next, required String confirm}) {
    final email = _sessionEmail?.toLowerCase();
    if (email == null || _passwords[email] != current) return 'Current password is not correct.';
    final passwordError = AppValidators.password(next);
    if (passwordError != null) return passwordError;
    if (next != confirm) return 'New passwords do not match.';
    _passwords[email] = next;
    return null;
  }

  String? resetPassword({required String email, required String next, required String confirm}) {
    final emailError = AppValidators.email(email);
    if (emailError != null) return emailError;
    final key = email.trim().toLowerCase();
    if (!_passwords.containsKey(key) || key == AppText.demoAdminEmail) {
      return 'No shop account was found for this email.';
    }
    final passwordError = AppValidators.password(next);
    if (passwordError != null) return passwordError;
    if (next != confirm) return 'Passwords do not match.';
    _passwords[key] = next;
    return null;
  }

  void rememberSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _recentSearches.remove(trimmed);
    _recentSearches.insert(0, trimmed);
    if (_recentSearches.length > 8) _recentSearches.removeLast();
    notifyListeners();
  }

  void clearSearches() {
    _recentSearches.clear();
    notifyListeners();
  }

  List<Product> search(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return _products;
    return _products.where((product) {
      return product.name.toLowerCase().contains(needle) ||
          product.category.toLowerCase().contains(needle) ||
          product.description.toLowerCase().contains(needle);
    }).toList();
  }

  bool isWished(String productId) => _wishlist.contains(productId);

  void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.insert(0, productId);
    }
    notifyListeners();
  }

  void addToCart(String productId, {int quantity = 1}) {
    final index = _cart.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _cart[index] = _cart[index].copyWith(quantity: _cart[index].quantity + quantity);
    } else {
      _cart.add(CartItem(productId: productId, quantity: quantity));
    }
    notifyListeners();
  }

  void setQuantity(String productId, int quantity) {
    final index = _cart.indexWhere((item) => item.productId == productId);
    if (index < 0) return;
    if (quantity <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index] = _cart[index].copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  String? applyCoupon(String code) {
    final formatError = AppValidators.promo(code);
    if (formatError != null) return formatError;
    final match = _coupons.where((coupon) => coupon.code.toLowerCase() == code.trim().toLowerCase());
    if (match.isEmpty) return 'That promo code is not recognised.';
    final coupon = match.first;
    if (!coupon.active) return 'This coupon is turned off.';
    if (DateTime.now().isAfter(coupon.validTill)) return 'This coupon has expired.';
    if (cartSubtotal < coupon.minOrder) return 'Add more to the cart to use ${coupon.code}.';
    _appliedCoupon = coupon.code;
    notifyListeners();
    return null;
  }

  void selectAddress(String id) {
    _selectedAddressId = id;
    notifyListeners();
  }

  void addAddress({required String label, required String name, required String lines, required String phone}) {
    final address = Address(
      id: 'addr${DateTime.now().millisecondsSinceEpoch}',
      label: label,
      name: name,
      lines: lines,
      phone: phone,
    );
    _addresses.add(address);
    _selectedAddressId = address.id;
    notifyListeners();
  }

  void selectPayment(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  String? placeOrder() {
    if (_cart.isEmpty) return 'Your cart is empty.';
    final address = selectedAddress;
    if (address == null) return 'Choose a shipping address.';
    final lines = <OrderLine>[];
    for (final item in _cart) {
      final product = productById(item.productId);
      if (product == null) continue;
      if (product.stock < item.quantity) return '${product.name} only has ${product.stock} left.';
      lines.add(OrderLine(productId: product.id, name: product.name, image: product.image, price: product.price, quantity: item.quantity));
    }
    for (final line in lines) {
      final index = _products.indexWhere((product) => product.id == line.productId);
      if (index >= 0) {
        _products[index] = _products[index].copyWith(stock: _products[index].stock - line.quantity);
      }
    }
    final id = '#TX${DateTime.now().millisecondsSinceEpoch}'.substring(0, 13);
    final order = ShopOrder(
      id: id,
      customerId: _customerId ?? 'guest',
      customerName: sessionName,
      placedAt: DateTime.now(),
      status: OrderStatus.pending,
      lines: lines,
      shipping: cartShipping,
      tax: cartTax,
      paymentMethod: _paymentMethod,
      paymentStatus: 'Paid',
      address: '${address.name}\n${address.lines}',
      timeline: {OrderStatus.pending: DateTime.now()},
    );
    _orders.insert(0, order);
    _payments.insert(0, PaymentRecord(id: '#PAY${id.replaceAll('#TX', '')}', customerName: sessionName, date: DateTime.now(), amount: order.total, status: 'Success'));
    _lastOrderId = id;
    _cart.clear();
    _appliedCoupon = null;
    notifyListeners();
    return null;
  }

  void saveProduct({
    String? id,
    required String name,
    required String category,
    required double price,
    required double discount,
    required int stock,
    required String description,
    required String image,
  }) {
    final compare = discount > 0 ? price + discount : null;
    if (id == null) {
      _products.insert(0, Product(id: 'p${DateTime.now().millisecondsSinceEpoch}', name: name, category: category, price: price, compareAtPrice: compare, stock: stock, image: image, description: description, isNew: true, subtitle: description));
    } else {
      final index = _products.indexWhere((product) => product.id == id);
      if (index >= 0) {
        _products[index] = _products[index].copyWith(name: name, category: category, price: price, compareAtPrice: compare, stock: stock, description: description, image: image);
      }
    }
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return;
    final current = _orders[index];
    final timeline = Map<OrderStatus, DateTime>.from(current.timeline);
    timeline[status] = DateTime.now();
    _orders[index] = current.copyWith(
      status: status,
      timeline: timeline,
      paymentStatus: status == OrderStatus.cancelled ? 'Refunded' : current.paymentStatus,
    );
    notifyListeners();
  }

  void setReviewStatus(String reviewId, ReviewStatus status) {
    final index = _reviews.indexWhere((review) => review.id == reviewId);
    if (index < 0) return;
    _reviews[index] = _reviews[index].copyWith(status: status);
    notifyListeners();
  }

  void toggleCoupon(String code, bool active) {
    final index = _coupons.indexWhere((coupon) => coupon.code == code);
    if (index < 0) return;
    _coupons[index] = _coupons[index].copyWith(active: active);
    notifyListeners();
  }

  void addCoupon({required String code, required int percent, required double minOrder, required DateTime validTill}) {
    _coupons.insert(0, Coupon(code: code.trim().toUpperCase(), percent: percent, minOrder: minOrder, validTill: validTill));
    notifyListeners();
  }

  void toggleBanner(String id, bool active) {
    final index = _banners.indexWhere((banner) => banner.id == id);
    if (index < 0) return;
    _banners[index] = _banners[index].copyWith(active: active);
    notifyListeners();
  }

  StoreBanner? get activeBanner => _banners.where((banner) => banner.active).firstOrNull;

  void sendNotification({required String audience, required String title, required String message, required DateTime sendAt}) {
    _notifications.insert(0, StoreNotification(id: 'n${DateTime.now().millisecondsSinceEpoch}', audience: audience, title: title, message: message, sendAt: sendAt));
    notifyListeners();
  }

  void updateStoreSettings({double? shippingFee, double? taxRate, String? currency}) {
    if (shippingFee != null) _shippingFee = shippingFee;
    if (taxRate != null) _taxRate = taxRate;
    if (currency != null) _currency = currency;
    notifyListeners();
  }

  Map<String, dynamic> toUploadPayload() => {
        'store': 'TEXTILES',
        'currency': _currency,
        'products': _products.map((product) => product.toJson()).toList(),
        'orders': _orders.map((order) => order.toJson()).toList(),
        'customers': _customers.map((customer) => customer.toJson()).toList(),
        'reviews': _reviews.map((review) => review.toJson()).toList(),
        'coupons': _coupons.map((coupon) => coupon.toJson()).toList(),
        'payments': _payments.map((payment) => payment.toJson()).toList(),
        'banners': _banners.map((banner) => banner.toJson()).toList(),
      };

  void _seed() {
    const description = 'Premium quality cotton shirt for men. Breathable fabric, perfect for casual and semi-formal occasions.';
    _products.addAll([
      const Product(id: 'p-monkey', name: 'Printed T-shirt', category: 'tshirts', price: 999, compareAtPrice: 1299, stock: 120, lowStockAt: 20, rating: 4.5, reviewCount: 128, image: AppImages.monkeyTee, description: description, subtitle: 'T Shirt is light and comfortabel', weeklySales: 40),
      const Product(id: 'p-plain', name: 'Plain TS blue', category: 'tshirts', price: 599, stock: 80, image: AppImages.gridTee, description: 'Best Collection', subtitle: 'Best Collection', rating: 4.6),
      const Product(id: 'p-sage', name: 'Essential Sage Tee', category: 'tshirts', price: 4999, stock: 36, rating: 4.8, reviewCount: 86, image: AppImages.poloMaroon, description: 'A deep maroon polo with the TEXTILES mark.', isNew: true, weeklySales: 64),
      const Product(id: 'p-cloud', name: 'CloudSoft Hoodie', category: 'hoodies', price: 6999, stock: 85, lowStockAt: 16, rating: 4.9, reviewCount: 74, image: AppImages.flameJacket, description: 'Flame print jacket with a soft shell lining.', isNew: true, weeklySales: 71),
      const Product(id: 'p-smoke', name: 'Printed T-shirts', category: 'tshirts', price: 2200, stock: 42, rating: 4.9, image: AppImages.smokeTee, description: 'Smoke print cotton tee.', weeklySales: 22),
      const Product(id: 'p-stripe', name: 'Oxford White Shirt', category: 'shirts', price: 1000, stock: 60, rating: 4.9, image: AppImages.stripeShirt, description: 'Crisp stripe shirt for everyday wear.', weeklySales: 98),
      const Product(id: 'p-tan', name: 'Shirts', category: 'shirts', price: 1999, stock: 22, rating: 4.9, image: AppImages.tanPlaid, description: 'Camel check flannel shirt.'),
      const Product(id: 'p-red', name: 'Shirts', category: 'shirts', price: 1000, stock: 18, lowStockAt: 20, rating: 4.9, image: AppImages.redPlaid, description: 'Classic red plaid shirt.'),
      const Product(id: 'p-jeans', name: 'Jeans', category: 'jeans', price: 1199, stock: 40, rating: 4.9, image: AppImages.blackJeans, description: 'Slim black denim with a clean wash.'),
      const Product(id: 'p-formal', name: 'Tailored Navy Suit', category: 'pants', price: 2499, stock: 16, lowStockAt: 20, rating: 4.8, image: AppImages.formalTrousers, description: 'Formal trouser cut for evening wear.', weeklySales: 124),
      const Product(id: 'p-gray', name: 'Pants', category: 'pants', price: 7999, stock: 70, image: AppImages.grayTrousers, description: 'Premium tailored trousers.'),
      const Product(id: 'p-varsity', name: 'Printed Jackets', category: 'jackets', price: 2999, stock: 18, lowStockAt: 20, rating: 4.9, image: AppImages.varsity, description: 'Varsity jacket with a tiger crest.'),
      const Product(id: 'p-scribble', name: 'Jackets', category: 'hoodies', price: 1199, stock: 85, lowStockAt: 16, rating: 4.9, image: AppImages.scribbleHoodie, description: 'All-over scribble zip hoodie.'),
      const Product(id: 'p-vest', name: 'Textiles Vest', category: 'accessories', price: 2199, stock: 17, lowStockAt: 20, rating: 4.4, image: AppImages.vest, description: 'Fleece vest with a chest wordmark.'),
      const Product(id: 'p-shorts', name: 'Short', category: 'shorts', price: 1499, stock: 27, rating: 4.5, image: AppImages.doodleShorts, description: 'Graphic print shorts.'),
    ]);
    _wishlist.addAll(['p-monkey', 'p-stripe', 'p-smoke', 'p-varsity', 'p-sage', 'p-tan']);
    _cart.addAll(const [CartItem(productId: 'p-monkey', quantity: 1), CartItem(productId: 'p-plain', quantity: 1)]);
    _customers.addAll([
      Customer(id: 'tirth', name: 'Tirth Kotak', email: AppText.demoShopEmail, phone: '+91 98765 43210', joinedOn: DateTime(2026, 1, 12)),
      Customer(id: 'yash', name: 'Yash Patel', email: 'yashpatel12@gmail.com', phone: '+91 12345 67890', joinedOn: DateTime(2026, 1, 12)),
      Customer(id: 'john', name: 'John Doe', email: 'john@gmail.com', phone: '+911234567890', joinedOn: DateTime(2025, 11, 2)),
      Customer(id: 'jane', name: 'Jane Smith', email: 'jane@gmail.com', phone: '+911345678901', joinedOn: DateTime(2025, 8, 18)),
      Customer(id: 'robert', name: 'Robert Brown', email: 'robert@gmail.com', phone: '+911435678902', joinedOn: DateTime(2025, 6, 9)),
      Customer(id: 'mark', name: 'Mark Bug', email: 'mark@gmail.com', phone: '+911543567893', joinedOn: DateTime(2025, 4, 21)),
    ]);
    _addresses.addAll(const [
      Address(id: 'home', label: 'Home', name: 'Eleanor Pemberton', lines: '482 Mulberry Lane, West Village\nNew York, NY 10014\nUnited States', phone: '+1 (212) 555-0198', isDefault: true),
      Address(id: 'office', label: 'Office', name: 'Eleanor Pemberton (Design Studio)', lines: '750 7th Ave, Floor 12\nNew York, NY 10019\nUnited States', phone: '+1 (212) 555-0144'),
    ]);
    _selectedAddressId = 'home';
    _orders.addAll([
      ShopOrder(
        id: '#TX123456789',
        customerId: 'john',
        customerName: 'John Doe',
        placedAt: DateTime(2026, 5, 12, 10, 30),
        status: OrderStatus.pending,
        paymentMethod: 'UPI',
        paymentStatus: 'Paid',
        shipping: 0,
        tax: 0,
        address: '123, MG Road, Bangelore,\nKarnataka - 560001',
        lines: const [
          OrderLine(productId: 'p-monkey', name: 'T-Shirt', image: AppImages.monkeyTee, price: 899, quantity: 1),
          OrderLine(productId: 'p-cloud', name: 'Jacket', image: AppImages.flameJacket, price: 1299, quantity: 1),
        ],
        timeline: {OrderStatus.pending: DateTime(2026, 5, 12, 10, 30)},
      ),
      ShopOrder(
        id: '#TX123456788',
        customerId: 'jane',
        customerName: 'Jane Smith',
        placedAt: DateTime(2026, 5, 11, 10, 49),
        status: OrderStatus.shipped,
        paymentMethod: 'Card',
        paymentStatus: 'Paid',
        shipping: 0,
        tax: 0,
        address: '12 Residency Road, Bengaluru',
        lines: const [OrderLine(productId: 'p-stripe', name: 'Shirts', image: AppImages.stripeShirt, price: 2100, quantity: 1)],
        timeline: {
          OrderStatus.pending: DateTime(2026, 5, 12, 10, 30),
          OrderStatus.confirmed: DateTime(2026, 5, 13, 10, 49),
          OrderStatus.packed: DateTime(2026, 5, 14, 11, 30),
          OrderStatus.shipped: DateTime(2026, 5, 15, 0, 49),
        },
      ),
      ShopOrder(
        id: '#TX123456707',
        customerId: 'robert',
        customerName: 'Robert Brown',
        placedAt: DateTime(2026, 5, 11),
        status: OrderStatus.delivered,
        paymentMethod: 'UPI',
        paymentStatus: 'Paid',
        shipping: 0,
        tax: 0,
        address: 'MG Road, Ahmedabad',
        lines: const [OrderLine(productId: 'p-monkey', name: 'T-Shirt', image: AppImages.monkeyTee, price: 899, quantity: 1)],
        timeline: {
          OrderStatus.pending: DateTime(2026, 5, 8, 10, 30),
          OrderStatus.delivered: DateTime(2026, 5, 11, 16, 0),
        },
      ),
      ShopOrder(
        id: '#TX123456786',
        customerId: 'mark',
        customerName: 'Mark Bug',
        placedAt: DateTime(2026, 5, 10),
        status: OrderStatus.cancelled,
        paymentMethod: 'Card',
        paymentStatus: 'Refunded',
        shipping: 0,
        tax: 0,
        address: 'CG Road, Ahmedabad',
        lines: const [OrderLine(productId: 'p-stripe', name: 'Shirt', image: AppImages.stripeShirt, price: 1899, quantity: 1)],
        timeline: {OrderStatus.pending: DateTime(2026, 5, 10, 9, 0), OrderStatus.cancelled: DateTime(2026, 5, 10, 18, 0)},
      ),
      ShopOrder(
        id: '#123',
        customerId: 'tirth',
        customerName: 'Tirth Kotak',
        placedAt: DateTime(2026, 5, 12),
        status: OrderStatus.pending,
        paymentMethod: 'UPI',
        paymentStatus: 'Paid',
        shipping: 0,
        tax: 0,
        address: 'Ahmedabad',
        lines: const [OrderLine(productId: 'p-monkey', name: 'T-Shirts', image: AppImages.monkeyTee, price: 899, quantity: 1)],
        timeline: {OrderStatus.pending: DateTime(2026, 5, 12)},
      ),
    ]);
    _payments.addAll([
      PaymentRecord(id: '#PAY123456', customerName: 'John Doe', date: DateTime(2026, 5, 12), amount: 1299, status: 'Success'),
      PaymentRecord(id: '#TX123456788', customerName: 'Jane Smith', date: DateTime(2026, 5, 11), amount: 2100, status: 'Success'),
      PaymentRecord(id: '#TX123456707', customerName: 'Robert Brown', date: DateTime(2026, 5, 11), amount: 899, status: 'Refunded'),
      PaymentRecord(id: '#TX123456786', customerName: 'Mark Bug', date: DateTime(2026, 5, 10), amount: 1499, status: 'Success'),
    ]);
    _reviews.addAll([
      ProductReview(id: 'r1', productName: 'T-Shirts', customerName: 'John Doe', date: DateTime(2026, 5, 12), stars: 5, comment: 'Great quality & beast fit.', status: ReviewStatus.approved),
      ProductReview(id: 'r2', productName: 'Denim Jacket', customerName: 'Jane Smith', date: DateTime(2026, 5, 11), stars: 4, comment: 'Very comfortable.', status: ReviewStatus.pending),
      ProductReview(id: 'r3', productName: 'Hoddie', customerName: 'Robert Brown', date: DateTime(2026, 5, 11), stars: 4, comment: 'Good but colar is slightly different.', status: ReviewStatus.rejected),
    ]);
    _coupons.addAll([
      Coupon(code: 'Welcome10', percent: 10, minOrder: 999, validTill: DateTime(2027, 12, 31)),
      Coupon(code: 'Summer20', percent: 20, minOrder: 1999, validTill: DateTime(2027, 12, 31)),
      Coupon(code: 'FREESHIP', percent: 10, minOrder: 2999, validTill: DateTime(2027, 12, 31), freeShipping: true),
    ]);
    _banners.add(const StoreBanner(id: 'hero', eyebrow: 'ARTISAN WOVEN', title: 'Mastering the\nCraft of Thread', action: 'Shop Collection', image: AppImages.lifestyle));
  }
}
