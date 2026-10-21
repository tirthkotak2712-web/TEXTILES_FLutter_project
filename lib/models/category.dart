import 'package:flutter/material.dart';

class StoreCategory {
  const StoreCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.image,
    this.blurb = 'This is best collection of Shop',
    this.onHome = false,
    this.onGrid = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final String? image;
  final String blurb;
  final bool onHome;
  final bool onGrid;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'blurb': blurb,
      };
}
