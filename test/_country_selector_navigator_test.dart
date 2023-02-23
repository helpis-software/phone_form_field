import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  group('CountrySelectorNavigator', () {
    Widget getApp(final Function(BuildContext ctx) cb) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (final BuildContext ctx) => ElevatedButton(
                onPressed: () => cb(ctx),
                child: const Text('press'),
              ),
            ),
          ),
        );

    testWidgets('should navigate to dialog', (final WidgetTester tester) async {
      const CountrySelectorNavigator nav = CountrySelectorNavigator.dialog();
      await tester
          .pumpWidget(getApp((final BuildContext ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelector), findsOneWidget);
    });

    testWidgets('should navigate to modal bottom sheet',
        (final WidgetTester tester) async {
      const CountrySelectorNavigator nav =
          CountrySelectorNavigator.modalBottomSheet();
      await tester
          .pumpWidget(getApp((final BuildContext ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelector), findsOneWidget);
    });

    testWidgets('should navigate to bottom sheet',
        (final WidgetTester tester) async {
      const CountrySelectorNavigator nav =
          CountrySelectorNavigator.bottomSheet();
      await tester
          .pumpWidget(getApp((final BuildContext ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelector), findsOneWidget);
    });

    testWidgets('should navigate to draggable sheet',
        (final WidgetTester tester) async {
      const CountrySelectorNavigator nav =
          CountrySelectorNavigator.draggableBottomSheet();
      await tester
          .pumpWidget(getApp((final BuildContext ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelector), findsOneWidget);
    });
  });
}
