class Coupon {
  const Coupon({
    required this.code,
    required this.percent,
    required this.minOrder,
    required this.validTill,
    this.active = true,
    this.freeShipping = false,
  });

  final String code;
  final int percent;
  final double minOrder;
  final DateTime validTill;
  final bool active;
  final bool freeShipping;

  String get offerLabel =>
      freeShipping && percent == 0 ? 'Free shipping' : '$percent% OFF';

  Coupon copyWith({bool? active}) {
    return Coupon(
      code: code,
      percent: percent,
      minOrder: minOrder,
      validTill: validTill,
      active: active ?? this.active,
      freeShipping: freeShipping,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'percent': percent,
        'minOrder': minOrder,
        'validTill': validTill.toIso8601String(),
        'active': active,
        'freeShipping': freeShipping,
      };
}
