import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/foundation.dart';

/// Country regroup informations for displaying a list of countries
@immutable
class Country {
  Country(this.isoCode, this.name)
      : countryCode = countriesCountryCode[isoCode]!;

  /// Country alpha-2 iso code
  final IsoCode isoCode;

  /// localized name of the country
  final String name;

  /// country dialing code to call them internationally
  final String countryCode;

  /// returns "+ [countryCode]"
  String get displayCountryCode => '+ $countryCode';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;

  @override
  String toString() => 'Country{isoCode: $isoCode}';
}
