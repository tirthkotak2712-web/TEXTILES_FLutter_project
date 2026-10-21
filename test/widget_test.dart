import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:textiles/main.dart';
import 'package:textiles/resources/app_text.dart';

void main() {
  testWidgets('Splash shows the TEXTILES logo', (tester) async {
    await tester.pumpWidget(const TextilesApp());
    expect(find.byKey(const Key('textiles-logo')), findsOneWidget);
    expect(find.text(AppText.tapToContinue), findsOneWidget);
  });
}
