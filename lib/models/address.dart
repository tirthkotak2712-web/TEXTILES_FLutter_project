class Address {
  const Address({
    required this.id,
    required this.label,
    required this.name,
    required this.lines,
    required this.phone,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String name;
  final String lines;
  final String phone;
  final bool isDefault;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'name': name,
        'lines': lines,
        'phone': phone,
        'isDefault': isDefault,
      };
}
