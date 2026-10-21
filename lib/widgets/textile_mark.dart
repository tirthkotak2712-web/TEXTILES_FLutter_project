import 'package:flutter/material.dart';
import 'package:textiles/resources/app_images.dart';
import 'package:textiles/resources/app_text.dart';

/// Woven plaid mark drawn for screens that do not use the logo file.
class TextileMark extends StatelessWidget {
  const TextileMark({
    super.key,
    this.size = 112,
    this.color = const Color(0xFF5C5C5C),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _TextileMarkPainter(color),
    );
  }
}

class _TextileMarkPainter extends CustomPainter {
  _TextileMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final s = size.width;
    const slots = [0.06, 0.24, 0.42, 0.60, 0.78];
    const weights = [0.11, 0.08, 0.14, 0.08, 0.11];

    for (var i = 0; i < slots.length; i++) {
      final thickness = s * weights[i];
      final start = s * slots[i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(start, s * 0.06, thickness, s * 0.88),
          Radius.circular(thickness * 0.35),
        ),
        paint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.06, start, s * 0.88, thickness),
          Radius.circular(thickness * 0.35),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TextileMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Logo file. Black in the artwork is dropped so the mark sits on the screen.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.width = 240});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppText.brand,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
        ]),
        child: Image.asset(
          AppImages.logo,
          key: const Key('textiles-logo'),
          width: width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
