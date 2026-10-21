class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
    required this.description,
    this.compareAtPrice,
    this.lowStockAt = 20,
    this.rating = 4.5,
    this.reviewCount = 12,
    this.isNew = false,
    this.weeklySales = 0,
    this.subtitle = '',
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final double? compareAtPrice;
  final int stock;
  final int lowStockAt;
  final double rating;
  final int reviewCount;
  final String description;
  final String image;
  final bool isNew;
  final int weeklySales;
  final String subtitle;

  bool get isLowStock => stock <= lowStockAt;

  int get discountPercent {
    final compare = compareAtPrice;
    if (compare == null || compare <= price) return 0;
    return (((compare - price) / compare) * 100).round();
  }

  Product copyWith({
    String? name,
    String? category,
    double? price,
    double? compareAtPrice,
    int? stock,
    int? lowStockAt,
    String? description,
    String? image,
    bool? isNew,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      stock: stock ?? this.stock,
      lowStockAt: lowStockAt ?? this.lowStockAt,
      rating: rating,
      reviewCount: reviewCount,
      description: description ?? this.description,
      image: image ?? this.image,
      isNew: isNew ?? this.isNew,
      weeklySales: weeklySales,
      subtitle: subtitle,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'compareAtPrice': compareAtPrice,
        'stock': stock,
        'lowStockAt': lowStockAt,
        'rating': rating,
        'reviewCount': reviewCount,
        'description': description,
        'image': image,
        'isNew': isNew,
        'weeklySales': weeklySales,
        'subtitle': subtitle,
      };
}
