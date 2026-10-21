enum OrderStatus { pending, confirmed, packed, shipped, delivered, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.confirmed => 'Confirmed',
        OrderStatus.packed => 'Packed',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };

  String get wire => name;
}

class OrderLine {
  const OrderLine({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;

  double get lineTotal => price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'image': image,
        'price': price,
        'quantity': quantity,
      };
}

class ShopOrder {
  const ShopOrder({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.placedAt,
    required this.status,
    required this.lines,
    required this.shipping,
    required this.tax,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.address,
    this.timeline = const {},
  });

  final String id;
  final String customerId;
  final String customerName;
  final DateTime placedAt;
  final OrderStatus status;
  final List<OrderLine> lines;
  final double shipping;
  final double tax;
  final String paymentMethod;
  final String paymentStatus;
  final String address;
  final Map<OrderStatus, DateTime> timeline;

  double get subtotal => lines.fold(0, (sum, line) => sum + line.lineTotal);

  double get total => subtotal + shipping + tax;

  ShopOrder copyWith({
    OrderStatus? status,
    Map<OrderStatus, DateTime>? timeline,
    String? paymentStatus,
  }) {
    return ShopOrder(
      id: id,
      customerId: customerId,
      customerName: customerName,
      placedAt: placedAt,
      status: status ?? this.status,
      lines: lines,
      shipping: shipping,
      tax: tax,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      address: address,
      timeline: timeline ?? this.timeline,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'customerName': customerName,
        'placedAt': placedAt.toIso8601String(),
        'status': status.wire,
        'lines': lines.map((line) => line.toJson()).toList(),
        'shipping': shipping,
        'tax': tax,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'address': address,
        'total': total,
      };
}
