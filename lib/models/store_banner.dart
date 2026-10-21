class StoreBanner {
  const StoreBanner({
    required this.id,
    required this.eyebrow,
    required this.title,
    required this.action,
    required this.image,
    this.active = true,
  });

  final String id;
  final String eyebrow;
  final String title;
  final String action;
  final String image;
  final bool active;

  StoreBanner copyWith({bool? active}) {
    return StoreBanner(
      id: id,
      eyebrow: eyebrow,
      title: title,
      action: action,
      image: image,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eyebrow': eyebrow,
        'title': title,
        'action': action,
        'image': image,
        'active': active,
      };
}
