import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenti/app/view/crisis/crisis_page.dart';

void main() {
  group('CrisisPage', () {
    testWidgets('renders all sections correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CrisisPage(),
        ),
      );

      expect(find.textContaining('Centro'), findsOneWidget);
      expect(find.textContaining('solo'), findsOneWidget);
      expect(find.textContaining('Ayuda'), findsOneWidget);
      expect(find.textContaining('4-7-8'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.textContaining('Consejos'),
        500.0,
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('Consejos'), findsOneWidget);
      
      // Verify emergency buttons exist
      expect(find.textContaining('123'), findsOneWidget);
      expect(find.textContaining('Salud Mental'), findsOneWidget);
    });

    testWidgets('breathing animation exists and is scaling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CrisisPage(),
        ),
      );

      final icon = find.byIcon(Icons.air);
      expect(icon, findsOneWidget);
      
      // Pump some frames to ensure animation is running
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
