import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';
import 'package:phone_form_field/src/helpers/localized_country_registry.dart';
import 'package:phone_form_field/src/models/iso_code.dart';

import '../../helpers/country_finder.dart';
import '../../models/country.dart';
import 'country_list.dart';
import 'search_box.dart';

class CountrySelector extends StatefulWidget {
  const CountrySelector({
    required this.onCountrySelected,
    super.key,
    this.scrollController,
    this.scrollPhysics,
    this.addFavoritesSeparator = true,
    this.showCountryCode = false,
    this.noResultMessage,
    this.favoriteCountries = const <IsoCode>[],
    this.countries,
    this.searchAutofocus = kIsWeb,
    this.subtitleStyle,
    this.titleStyle,
    this.searchBoxDecoration,
    this.searchBoxTextStyle,
    this.searchBoxIconColor,
    this.flagSize = 40,
  });

  /// List of countries to display in the selector
  /// Value optional in constructor.
  /// when omitted, the full country list is displayed
  final List<IsoCode>? countries;

  /// Callback triggered when user select a country
  final ValueChanged<Country> onCountrySelected;

  /// ListView.builder scroll controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// The [ScrollPhysics] of the Country List
  final ScrollPhysics? scrollPhysics;

  /// Determine the countries to be displayed on top of the list
  /// Check [addFavoritesSeparator] property to enable/disable adding a
  /// list divider between favorites and others defaults countries
  final List<IsoCode> favoriteCountries;

  /// Whether to add a list divider between favorites & defaults
  /// countries.
  final bool addFavoritesSeparator;

  /// Whether to show the country country code (ie: +1 / +33 /...)
  /// as a listTile subtitle
  final bool showCountryCode;

  /// The message displayed instead of the list when the search has no results
  final String? noResultMessage;

  /// whether the search input is auto focussed
  final bool searchAutofocus;

  /// The [TextStyle] of the country subtitle
  final TextStyle? subtitleStyle;

  /// The [TextStyle] of the country title
  final TextStyle? titleStyle;

  /// The [InputDecoration] of the Search Box
  final InputDecoration? searchBoxDecoration;

  /// The [TextStyle] of the Search Box
  final TextStyle? searchBoxTextStyle;

  /// The [Color] of the Search Icon in the Search Box
  final Color? searchBoxIconColor;
  final double flagSize;

  @override
  CountrySelectorState createState() => CountrySelectorState();
  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<IsoCode>('countries', countries))
      ..add(DoubleProperty('flagSize', flagSize))
      ..add(ColorProperty('searchBoxIconColor', searchBoxIconColor))
      ..add(
        DiagnosticsProperty<TextStyle?>(
          'searchBoxTextStyle',
          searchBoxTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty<InputDecoration?>(
          'searchBoxDecoration',
          searchBoxDecoration,
        ),
      )
      ..add(DiagnosticsProperty<TextStyle?>('titleStyle', titleStyle))
      ..add(DiagnosticsProperty<TextStyle?>('subtitleStyle', subtitleStyle))
      ..add(DiagnosticsProperty<bool>('searchAutofocus', searchAutofocus))
      ..add(StringProperty('noResultMessage', noResultMessage))
      ..add(DiagnosticsProperty<bool>('showCountryCode', showCountryCode))
      ..add(
        DiagnosticsProperty<bool>(
          'addFavoritesSeparator',
          addFavoritesSeparator,
        ),
      )
      ..add(IterableProperty<IsoCode>('favoriteCountries', favoriteCountries))
      ..add(
        DiagnosticsProperty<ScrollPhysics?>('scrollPhysics', scrollPhysics),
      )
      ..add(
        DiagnosticsProperty<ScrollController?>(
          'scrollController',
          scrollController,
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<Country>>.has(
          'onCountrySelected',
          onCountrySelected,
        ),
      );
  }
}

class CountrySelectorState extends State<CountrySelector> {
  late CountryFinder _countryFinder;
  late CountryFinder _favoriteCountryFinder;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final PhoneFieldLocalization localization =
        PhoneFieldLocalization.of(context) ?? PhoneFieldLocalizationEn();
    final List<IsoCode> isoCodes = widget.countries ?? IsoCode.values;
    final LocalizedCountryRegistry countryRegistry =
        LocalizedCountryRegistry.cached(localization);
    final List<Country> notFavoriteCountries = countryRegistry.whereIsoIn(
      isoCodes,
      omit: widget.favoriteCountries,
    );
    final List<Country> favoriteCountries = countryRegistry.whereIsoIn(
      widget.favoriteCountries,
    );
    _countryFinder = CountryFinder(notFavoriteCountries);
    _favoriteCountryFinder = CountryFinder(favoriteCountries, sort: false);
  }

  void _onSearch(final String searchedText) {
    _countryFinder.filter(searchedText);
    _favoriteCountryFinder.filter(searchedText);
    setState(() {});
  }

  void onSubmitted() {
    if (_favoriteCountryFinder.filteredCountries.isNotEmpty) {
      widget.onCountrySelected(_favoriteCountryFinder.filteredCountries.first);
    } else if (_countryFinder.filteredCountries.isNotEmpty) {
      widget.onCountrySelected(_countryFinder.filteredCountries.first);
    }
  }

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(
            height: 70,
            width: double.infinity,
            child: SearchBox(
              autofocus: widget.searchAutofocus,
              onChanged: _onSearch,
              onSubmitted: onSubmitted,
              decoration: widget.searchBoxDecoration,
              style: widget.searchBoxTextStyle,
              searchIconColor: widget.searchBoxIconColor,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 0, thickness: 1.2),
          Flexible(
            child: CountryList(
              favorites: _favoriteCountryFinder.filteredCountries,
              countries: _countryFinder.filteredCountries,
              showDialCode: widget.showCountryCode,
              onTap: widget.onCountrySelected,
              flagSize: widget.flagSize,
              scrollController: widget.scrollController,
              scrollPhysics: widget.scrollPhysics,
              noResultMessage: widget.noResultMessage,
              titleStyle: widget.titleStyle,
              subtitleStyle: widget.subtitleStyle,
            ),
          ),
        ],
      );
}
