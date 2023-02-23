import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../l10n/generated/phone_field_localization.dart';
import '../../models/country.dart';

class CountryList extends StatelessWidget {
  CountryList({
    required this.countries,
    required this.favorites,
    required this.onTap,
    required this.noResultMessage,
    super.key,
    this.scrollController,
    this.scrollPhysics,
    this.showDialCode = true,
    this.flagSize = 40,
    this.subtitleStyle,
    this.titleStyle,
  }) {
    _allListElement = <Country?>[
      ...favorites,
      if (favorites.isNotEmpty) null, // delimiter
      ...countries,
    ];
  }

  /// Callback function triggered when user select a country
  final Function(Country) onTap;

  /// List of countries to display
  final List<Country> countries;
  final double flagSize;

  /// list of favorite countries to display at the top
  final List<Country> favorites;

  /// proxy to the ListView.builder controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// The [ScrollPhysics] of the Country List
  final ScrollPhysics? scrollPhysics;

  /// whether the country dialcode should be displayed as the [ListTile.subtitle]
  final bool showDialCode;

  final String? noResultMessage;

  late final List<Country?> _allListElement;

  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;

  @override
  Widget build(final BuildContext context) {
    if (_allListElement.isEmpty) {
      return Center(
        child: Text(
          noResultMessage ??
              PhoneFieldLocalization.of(context)?.noResultMessage ??
              'No result found',
          key: const ValueKey<String>('no-result'),
        ),
      );
    }
    return ListView.builder(
      physics: scrollPhysics,
      controller: scrollController,
      itemCount: _allListElement.length,
      itemBuilder: (final BuildContext context, final int index) {
        final Country? country = _allListElement[index];
        if (country == null) {
          return const Divider(key: ValueKey<String>('countryListSeparator'));
        }

        return ListTile(
          key: ValueKey<String>(country.isoCode.name),
          leading: CircleFlag(
            country.isoCode.name,
            size: flagSize,
          ),
          title: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              country.name,
              textAlign: TextAlign.start,
              style: titleStyle,
            ),
          ),
          subtitle: showDialCode
              ? Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    country.displayCountryCode,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                    style: subtitleStyle,
                  ),
                )
              : null,
          onTap: () => onTap(country),
        );
      },
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<Function(Country p1)>.has('onTap', onTap))
      ..add(DiagnosticsProperty<TextStyle?>('titleStyle', titleStyle))
      ..add(DiagnosticsProperty<TextStyle?>('subtitleStyle', subtitleStyle))
      ..add(StringProperty('noResultMessage', noResultMessage))
      ..add(DiagnosticsProperty<bool>('showDialCode', showDialCode))
      ..add(
        DiagnosticsProperty<ScrollPhysics?>('scrollPhysics', scrollPhysics),
      )
      ..add(
        DiagnosticsProperty<ScrollController?>(
          'scrollController',
          scrollController,
        ),
      )
      ..add(IterableProperty<Country>('favorites', favorites))
      ..add(DoubleProperty('flagSize', flagSize))
      ..add(IterableProperty<Country>('countries', countries));
  }
}
