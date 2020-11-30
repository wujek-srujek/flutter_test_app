import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/main.dart';

void main() {
  testWidgets('clicking tabs switches to them', (tester) async {
    await tester.pumpWidget(App());

    final tabBarViewFinder = find.byType(TabBarView);
    expect(tabBarViewFinder, findsOneWidget);

    final leftTabHeaderFinder = find.text('LEFT');
    expect(leftTabHeaderFinder, findsOneWidget);

    final rightTabHeaderFinder = find.text('RIGHT');
    expect(rightTabHeaderFinder, findsOneWidget);

    expect(find.text('This is the LEFT tab'), findsOneWidget);

    await tester.tap(rightTabHeaderFinder);
    await tester.pump();
    await tester.pump(Duration(days: 365));

    expect(find.text('This is the RIGHT tab'), findsOneWidget);
  });

  testWidgets(
    'clicking the button changes tab background color',
    (tester) async {
      await tester.pumpWidget(App());

      final containerFinder = find.descendant(
        of: find.byType(TabBarView),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsOneWidget);

      final whiteContainer = tester.widget<Container>(containerFinder);
      expect(whiteContainer.color, Colors.white);

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();
      await tester.pump(kSleepDuration);

      final yellowContainer = tester.widget<Container>(containerFinder);
      expect(yellowContainer.color, Colors.yellow);
    },
  );
}
