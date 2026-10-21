enum ReviewStatus { pending, approved, rejected }

extension ReviewStatusLabel on ReviewStatus {
  String get label => switch (this) {
        ReviewStatus.pending => 'Pending',
        ReviewStatus.approved => 'Approved',
        ReviewStatus.rejected => 'Rejected',
      };
}

class ProductReview {
  const ProductReview({
    required this.id,
    required this.productName,
    required this.customerName,
    required this.date,
    required this.stars,
    required this.comment,
    required this.status,
  });

  final String id;
  final String productName;
  final String customerName;
  final DateTime date;
  final int stars;
  final String comment;
  final ReviewStatus status;

  ProductReview copyWith({ReviewStatus? status}) {
    return ProductReview(
      id: id,
      productName: productName,
      customerName: customerName,
      date: date,
      stars: stars,
      comment: comment,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productName': productName,
        'customerName': customerName,
        'date': date.toIso8601String(),
        'stars': stars,
        'comment': comment,
        'status': status.name,
      };
}
