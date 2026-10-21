class PaymentRecord {
  const PaymentRecord({
    required this.id,
    required this.customerName,
    required this.date,
    required this.amount,
    required this.status,
  });

  final String id;
  final String customerName;
  final DateTime date;
  final double amount;
  final String status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'date': date.toIso8601String(),
        'amount': amount,
        'status': status,
      };
}
