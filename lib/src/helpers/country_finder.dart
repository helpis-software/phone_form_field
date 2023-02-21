// responsible of searching through the country list

import 'package:diacritic/diacritic.dart';
import 'package:phone_form_field/src/models/iso_code.dart';

import '../models/country.dart';

class CountryFinder {
  CountryFinder(final List<Country> allCountries, {final bool sort = true}) {
    _allCountries = <Country>[...allCountries];
    if (sort) {
      _allCountries.sort(
        (final Country a, final Country b) => a.name.compareTo(b.name),
      );
    }
    _filteredCountries = <Country>[..._allCountries];
  }
  late final List<Country> _allCountries;
  late List<Country> _filteredCountries;
  List<Country> get filteredCountries => _filteredCountries;

  bool get isNotEmpty => _filteredCountries.isNotEmpty;
  String _searchedText = '';
  String get searchedText => _searchedText;

  // filter a
  void filter(final String txt) {
    if (txt == _searchedText) {
      return;
    }
    _searchedText = txt;
    // reset search
    if (txt.isEmpty) {
      _filteredCountries = <Country>[..._allCountries];
    }

    // if the txt is a number we check the country code instead
    final int? asInt = int.tryParse(txt);
    final bool isInt = asInt != null;
    if (isInt) {
      // toString to remove any + in front if its an int
      _filterByCountryCallingCode(txt);
    } else {
      _filterByName(txt);
    }
  }

  void _filterByCountryCallingCode(final String countryCallingCode) {
    int getSortPoint(final Country country) =>
        country.countryCode == countryCallingCode ? 1 : 0;

    _filteredCountries = _allCountries
        .where(
          (final Country country) =>
              country.countryCode.contains(countryCallingCode),
        )
        .toList()
      // puts the closest match at the top
      ..sort(
        (final Country a, final Country b) => getSortPoint(b) - getSortPoint(a),
      );
  }

  void _filterByName(final String searchTxt) {
    final String searchText = removeDiacritics(searchTxt.toLowerCase());
    // since we keep countries that contain the searched text,
    // we need to put the countries that start with that text in front.
    int getSortPoint(final String name, final IsoCode isoCode) {
      final bool isStartOfString = name.startsWith(searchText) ||
          isoCode.name.toLowerCase().startsWith(searchText);
      return isStartOfString ? 1 : 0;
    }

    int compareCountries(final Country a, final Country b) {
      final int sortPoint =
          getSortPoint(b.name, b.isoCode) - getSortPoint(a.name, a.isoCode);
      // sort alphabetically when comparison with search term get same result
      return sortPoint == 0 ? a.name.compareTo(b.name) : sortPoint;
    }

    _filteredCountries = _allCountries.where((final Country country) {
      final String countryName = removeDiacritics(country.name.toLowerCase());
      return countryName.contains(searchText);
    }).toList()
      // puts the ones that begin by txt first
      ..sort(compareCountries);
  }
}
