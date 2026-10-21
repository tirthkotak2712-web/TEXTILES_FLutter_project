class CartItem {
  const CartItem({required this.productId, required this.quantity});

  final String productId;
  final int quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(productId: productId, quantity: quantity ?? this.quantity);
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}
