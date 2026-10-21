import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/theme/app_theme.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_text.dart';
import 'package:textiles/screens/user/splash_screen.dart';

void main() {
  runApp(const TextilesApp());
}

class TextilesApp extends StatelessWidget {
  const TextilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreRepository(),
      child: MaterialApp(
        title: AppText.brand,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
