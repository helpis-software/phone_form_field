// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';

typedef _PhoneValidatorMessageDelegate = String? Function(BuildContext context);

class ValidatorTranslator {
  static final Map<String, _PhoneValidatorMessageDelegate> _validatorMessages =
      <String, _PhoneValidatorMessageDelegate>{
    'invalidPhoneNumber': (final BuildContext ctx) =>
        PhoneFieldLocalization.of(ctx)?.invalidPhoneNumber,
    'invalidCountry': (final BuildContext ctx) =>
        PhoneFieldLocalization.of(ctx)?.invalidCountry,
    'invalidMobilePhoneNumber': (final BuildContext ctx) =>
        PhoneFieldLocalization.of(ctx)?.invalidMobilePhoneNumber,
    'invalidFixedLinePhoneNumber': (final BuildContext ctx) =>
        PhoneFieldLocalization.of(ctx)?.invalidFixedLinePhoneNumber,
    'requiredPhoneNumber': (final BuildContext ctx) =>
        PhoneFieldLocalization.of(ctx)?.requiredPhoneNumber,
  };

  static final Map<String, String> _defaults = <String, String>{
    'invalidPhoneNumber': 'Invalid phone number',
    'invalidCountry': 'Invalid country',
    'invalidMobilePhoneNumber': 'Invalid mobile phone number',
    'invalidFixedLinePhoneNumber': 'Invalid fixedline phone number',
    'requiredPhoneNumber': 'required phone number',
  };

  /// Localised name depending on the current application locale
  /// If you have many LocalisedName to handle in a same context, consider
  /// supplying the second optional PhoneFieldLocalization to avoid
  /// walking up the widget to get [PhoneFieldLocalization] instance
  /// for each call.
  static String message(
    final BuildContext context,
    final String key,
  ) {
    final String? name = getMessageFromKey(context, key);
    return name ?? _defaults[key] ?? key;
  }

  static String? getMessageFromKey(final BuildContext ctx, final String key) {
    final _PhoneValidatorMessageDelegate? translateFn = _validatorMessages[key];
    return translateFn?.call(ctx);
  }
}
