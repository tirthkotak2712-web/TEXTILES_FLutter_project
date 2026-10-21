import 'package:flutter/material.dart';

abstract final class AppColors {
  static const green = Color(0xFF178A34);
  static const greenDark = Color(0xFF0E6B28);
  static const greenSoft = Color(0xFFE7F6EA);
  static const field = Color(0xFFF2F7F1);
  static const ink = Color(0xFF141414);
  static const muted = Color(0xFF8D8D93);
  static const line = Color(0xFFE6E6E6);
  static const danger = Color(0xFFD02020);
  static const orange = Color(0xFFE67A00);
  static const blue = Color(0xFF1E88E5);
  static const cream = Color(0xFFF7F4EF);
  static const star = Color(0xFFF5C518);
  static const card = Color(0xFFFFFFFF);
}

abstract final class AppStyles {
  static const radius = 14.0;
  static const buttonHeight = 54.0;

  static InputDecoration field({
    required String hint,
    Widget? suffix,
    Widget? prefix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 15),
      filled: true,
      fillColor: AppColors.field,
      suffixIcon: suffix,
      prefixIcon: prefix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _border(AppColors.line),
      enabledBorder: _border(AppColors.line),
      focusedBorder: _border(AppColors.green, width: 1.4),
      errorBorder: _border(AppColors.danger),
      focusedErrorBorder: _border(AppColors.danger, width: 1.4),
      errorStyle: const TextStyle(color: AppColors.danger, fontSize: 12),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static BoxDecoration card({Color? color, bool selected = false}) {
    return BoxDecoration(
      color: color ?? AppColors.card,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: selected ? AppColors.green : const Color(0xFFD9D9D9),
        width: selected ? 1.4 : 1,
      ),
    );
  }
}
