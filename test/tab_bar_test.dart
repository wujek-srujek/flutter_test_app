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
}
