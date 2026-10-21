class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.joinedOn,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime joinedOn;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'joinedOn': joinedOn.toIso8601String(),
      };
}
