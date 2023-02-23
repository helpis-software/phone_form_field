import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/src/models/iso_code.dart';

import '../models/country.dart';

class CountryCodeChip extends StatelessWidget {
  CountryCodeChip({
    required final IsoCode isoCode,
    super.key,
    this.textStyle = const TextStyle(),
    this.showFlag = true,
    this.showDialCode = true,
    this.padding = const EdgeInsets.all(20),
    this.flagSize = 20,
    this.textDirection,
  }) : country = Country(isoCode, '');
  final Country country;
  final bool showFlag;
  final bool showDialCode;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double flagSize;
  final TextDirection? textDirection;

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showFlag) ...<Widget>[
            CircleFlag(
              country.isoCode.name,
              size: flagSize,
            ),
            const SizedBox(width: 8),
          ],
          if (showDialCode)
            Text(
              country.displayCountryCode,
              style: textStyle,
              textDirection: textDirection,
            ),
        ],
      );
  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Country>('country', country))
      ..add(EnumProperty<TextDirection?>('textDirection', textDirection))
      ..add(DoubleProperty('flagSize', flagSize))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding))
      ..add(DiagnosticsProperty<TextStyle>('textStyle', textStyle))
      ..add(DiagnosticsProperty<bool>('showDialCode', showDialCode))
      ..add(DiagnosticsProperty<bool>('showFlag', showFlag));
  }
}
