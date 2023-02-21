import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/widgets/country_selector/search_box.dart';

void main() {
  group('CountrySelector', () {
    group('Without internationalization', () {
      final MaterialApp app = MaterialApp(
        home: Scaffold(
          body: CountrySelector(onCountrySelected: (final Country c) {}),
        ),
      );

      testWidgets('Should filter with text', (final WidgetTester tester) async {
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();
        final Finder txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'sp');
        await tester.pumpAndSettle();
        final Finder tiles = find.byType(ListTile);
        expect(tiles, findsWidgets);
        expect(
          tester.widget<ListTile>(tiles.first).key,
          equals(const Key('ES')),
        );
        // not the right language (we let english go through tho)
        await tester.enterText(txtFound, 'Espagne');
        await tester.pumpAndSettle();
        expect(tiles, findsNothing);
        await tester.pumpAndSettle();
        // country codes
        await tester.enterText(txtFound, '33');
        await tester.pumpAndSettle();
        expect(tiles, findsWidgets);
        expect(
          tester.widget<ListTile>(tiles.first).key,
          equals(const Key('FR')),
        );
      });
    });

    group('With internationalization', () {
      final MaterialApp app = MaterialApp(
        locale: const Locale('es', ''),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          ...GlobalMaterialLocalizations.delegates,
          PhoneFieldLocalization.delegate,
        ],
        supportedLocales: const <Locale>[Locale('es', '')],
        home: Scaffold(
          body: CountrySelector(onCountrySelected: (final Country c) {}),
        ),
      );

      testWidgets('Should filter with text', (final WidgetTester tester) async {
        await tester.pumpWidget(app);
        await tester.pump(const Duration(seconds: 1));
        final Finder txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'esp');
        await tester.pump(const Duration(seconds: 1));
        final Finder tiles = find.byType(ListTile);
        expect(tiles, findsWidgets);
        expect(
          tester.widget<ListTile>(tiles.first).key,
          equals(const Key('ES')),
        );
        // not the right language (we let english go through tho)
        await tester.enterText(txtFound, 'Espagne');
        await tester.pump(const Duration(seconds: 1));
        expect(tiles, findsNothing);
        await tester.pump(const Duration(seconds: 1));
        // country codes
        await tester.enterText(txtFound, '33');
        await tester.pump(const Duration(seconds: 1));
        expect(tiles, findsWidgets);
        expect(
          tester.widget<ListTile>(tiles.first).key,
          equals(const Key('FR')),
        );
      });
    });

    group('sorted countries with or without favorites', () {
      Widget builder({
        final List<IsoCode>? favorites,
        final bool addFavoritesSeparator = false,
      }) =>
          MaterialApp(
            locale: const Locale('fr'),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              PhoneFieldLocalization.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: const <Locale>[Locale('fr')],
            home: Scaffold(
              body: CountrySelector(
                onCountrySelected: (final Country c) {},
                addFavoritesSeparator: addFavoritesSeparator,
                favoriteCountries: favorites ?? const <IsoCode>[],
              ),
            ),
          );

      testWidgets('should be properly sorted without favorites',
          (final WidgetTester tester) async {
        await tester.pumpWidget(builder());
        await tester.pump(const Duration(seconds: 1));
        final Finder allTiles = find.byType(ListTile);
        expect(allTiles, findsWidgets);
        // expect(tester.widget<ListTile>(allTiles.first).key, equals(Key('AF')));
      });

      testWidgets('should be properly sorted with favorites',
          (final WidgetTester tester) async {
        await tester.pumpWidget(
          builder(
            favorites: <IsoCode>[IsoCode.GU, IsoCode.GY],
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        final Finder allTiles = find.byType(ListTile, skipOffstage: false);
        expect(allTiles, findsWidgets);
        expect(
          tester.widget<ListTile>(allTiles.at(0)).key,
          equals(Key(IsoCode.GU.name)),
        );
        expect(
          tester.widget<ListTile>(allTiles.at(1)).key,
          equals(Key(IsoCode.GY.name)),
        );

        final Finder txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'guy');
        await tester.pumpAndSettle();
        final Finder filteredTiles = find.byType(ListTile);
        expect(filteredTiles, findsWidgets);
        expect(filteredTiles.evaluate().length, equals(2));
      });

      testWidgets('should display/hide separator',
          (final WidgetTester tester) async {
        await tester.pumpWidget(
          builder(
            favorites: <IsoCode>[IsoCode.GU, IsoCode.GY],
            addFavoritesSeparator: true,
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        final Finder list = find.byType(ListView);
        expect(list, findsOneWidget);
        final Finder allTiles = find.descendant(
          of: list,
          matching: find.byWidgetPredicate(
            (final Widget widget) => widget is ListTile || widget is Divider,
          ),
        );

        expect(allTiles, findsWidgets);
        expect(
          tester.widget(allTiles.at(2)),
          isA<Divider>(),
          reason: 'separator should be visible after the favorites countries',
        );

        final Finder txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'guy');
        await tester.pump(const Duration(seconds: 1));
        final Finder tiles = find.byType(ListTile);
        expect(tiles, findsWidgets);
        expect(
          tiles.evaluate().length,
          equals(2),
          reason: 'Separator should be hidden as all elements '
              'found are in favorites',
        );
      });
    });

    group('Empty search result', () {
      Widget builder({
        final String? noResultMessage,
      }) =>
          MaterialApp(
            locale: const Locale('fr'),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              PhoneFieldLocalization.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: const <Locale>[Locale('fr')],
            home: Scaffold(
              body: CountrySelector(
                onCountrySelected: (final Country c) {},
                noResultMessage: noResultMessage,
              ),
            ),
          );

      testWidgets('should display default untranslated no result message',
          (final WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CountrySelector(
                onCountrySelected: (final Country c) {},
              ),
            ),
          ),
        );

        final Finder txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'fake search with no result');
        await tester.pumpAndSettle();

        // no listitem should be displayed when no result found
        final Finder allTiles = find.byType(ListTile);
        expect(allTiles, findsNothing);

        final Finder noResultWidget = find.text('No result found');
        expect(noResultWidget, findsOneWidget);
      });

      testWidgets('should display default translated no result message',
          (final WidgetTester tester) async {
        await tester.pumpWidget(builder());

        final Finder txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'fake search with no result');
        await tester.pumpAndSettle();

        // no listitem should be displayed when no result found
        final Finder allTiles = find.byType(ListTile);
        expect(allTiles, findsNothing);

        final Finder noResultWidget = find.text('Aucun résultat');
        expect(noResultWidget, findsOneWidget);
      });

      testWidgets('should display custom no result message',
          (final WidgetTester tester) async {
        await tester.pumpWidget(builder(noResultMessage: 'Bad news !'));

        final Finder txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'fake search with no result');
        await tester.pumpAndSettle();

        // no listitem should be displayed when no result found
        final Finder allTiles = find.byType(ListTile);
        expect(allTiles, findsNothing);

        final Finder noResultWidget = find.text('Bad news !');
        expect(noResultWidget, findsOneWidget);
      });
    });
  });
}
