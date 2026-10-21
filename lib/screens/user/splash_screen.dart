import 'package:flutter/material.dart';
import 'package:textiles/resources/app_images.dart';
import 'package:textiles/resources/app_text.dart';
import 'package:textiles/screens/user/login_screen.dart';
import 'package:textiles/widgets/textile_mark.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppImages.lifestyle, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.85,
                  colors: [
                    const Color(0xFFF6F1E8).withValues(alpha: 0.94),
                    const Color(0xFFF6F1E8).withValues(alpha: 0.55),
                    const Color(0xFFF6F1E8).withValues(alpha: 0.15),
                  ],
                ),
              ),
            ),
            const SafeArea(
              child: Column(
                children: [
                  Spacer(flex: 3),
                  BrandLogo(width: 360),
                  Text(
                    AppText.tagline,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  Spacer(flex: 2),
                  Text(
                    AppText.tapToContinue,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
