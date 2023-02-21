import 'dart:async';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/patterns.dart';
import 'package:phone_form_field/src/helpers/validator_translator.dart';
import 'package:phone_form_field/src/models/phone_controller.dart';
import 'package:phone_form_field/src/models/phone_field_controller.dart';
import 'package:phone_form_field/src/validator/phone_validator.dart';
import 'package:phone_form_field/src/widgets/phone_field.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_selector/country_selector_navigator.dart';

part 'phone_form_field_state.dart';

/// Phone input extending form field.
///
/// ### controller:
/// {@template controller}
/// Use a [PhoneController] for PhoneFormField when you need to dynamically
/// change the value.
///
/// Whenever the user modifies the phone field with an
/// associated [controller], the phone field updates
/// the display value and the controller notifies its listeners.
/// {@endtemplate}
///
/// You can also use an [initialValue]:
/// {@template initialValue}
/// The initial value used.
///
/// Only one of [initialValue] and [controller] can be specified.
/// If [controller] is specified the [initialValue] will be
/// the first value of the [PhoneController]
/// {@endtemplate}
///
/// ### formatting:
/// {@template shouldFormat}
/// Specify whether the field will format the national number with [shouldFormat] = true (default)
/// eg: +33677784455 will be displayed as +33 6 77 78 44 55.
///
/// The formats are localized for the country code.
/// eg: +1 677-784-455 & +33 6 77 78 44 55
///
///
/// This does not affect the output value, only the display.
/// Therefor `onSizeFound` will still return a [PhoneNumber]
/// with nsn of 677784455.
/// {@endtemplate}
///
/// ### phoneNumberType:
/// {@template phoneNumberType}
/// specify the type of phone number with `phoneNumberType`.
///
/// accepted values are:
///   - null (can be mobile or fixedLine)
///   - mobile
///   - fixedLine
/// {@endtemplate}
///
///
/// ### Country picker:
///
/// {@template selectorNavigator}
/// specify which type of country selector will be shown with
/// [PhoneField.selectorNavigator].
///
/// Uses one of:
///  - const BottomSheetNavigator()
///  - const DraggableModalBottomSheetNavigator()
///  - const ModalBottomSheetNavigator()
///  - const DialogNavigator()
/// {@endtemplate}
///
/// ### Country Code visibility:
///
/// The country dial code will be visible when:
/// - the field is focussed.
/// - the field has a value for national number.
/// - the field has no label obstructing the view.
class PhoneFormField extends FormField<PhoneNumber> {
  PhoneFormField({
    super.key,
    this.controller,
    this.shouldFormat = true,
    this.onChanged,
    this.focusNode,
    final bool showFlagInInput = true,
    final CountrySelectorNavigator countrySelectorNavigator =
        const CountrySelectorNavigator.searchDelegate(),
    Function(PhoneNumber?)? super.onSaved,
    this.defaultCountry = IsoCode.US,
    final InputDecoration decoration =
        const InputDecoration(border: UnderlineInputBorder()),
    AutovalidateMode super.autovalidateMode =
        AutovalidateMode.onUserInteraction,
    final PhoneNumber? initialValue,
    final double flagSize = 16,
    final PhoneNumberInputValidator? validator,
    final bool isCountrySelectionEnabled = true,
    final bool isCountryChipPersistent = false,
    // textfield inputs
    final TextInputType keyboardType = TextInputType.phone,
    final TextInputAction? textInputAction,
    final TextStyle? style,
    final TextStyle? countryCodeStyle,
    final StrutStyle? strutStyle,
    final TextAlign textAlign = TextAlign.start,
    final TextAlignVertical? textAlignVertical,
    final bool autofocus = false,
    final String obscuringCharacter = '*',
    final bool obscureText = false,
    final bool autocorrect = true,
    final SmartDashesType? smartDashesType,
    final SmartQuotesType? smartQuotesType,
    final bool enableSuggestions = true,
    final EditableTextContextMenuBuilder? toolbarContextMenuBuilder,
    final bool? showCursor,
    final VoidCallback? onEditingComplete,
    final ValueChanged<String>? onSubmitted,
    final AppPrivateCommandCallback? onAppPrivateCommand,
    final List<TextInputFormatter>? inputFormatters,
    super.enabled,
    final double cursorWidth = 2.0,
    final double? cursorHeight,
    final Radius? cursorRadius,
    final Color? cursorColor,
    final ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    final ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    final Brightness? keyboardAppearance,
    final EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    final bool enableInteractiveSelection = true,
    final TextSelectionControls? selectionControls,
    final MouseCursor? mouseCursor,
    final ScrollPhysics? scrollPhysics,
    final ScrollController? scrollController,
    final Iterable<String>? autofillHints,
    super.restorationId,
    final bool enableIMEPersonalizedLearning = true,
  })  : assert(
          initialValue == null || controller == null,
          'One of initialValue or controller can be specified at a time',
        ),
        super(
          initialValue: controller?.initialValue ?? initialValue,
          validator: validator ?? PhoneValidator.valid(),
          builder: (final FormFieldState<PhoneNumber> state) {
            final PhoneFormFieldState field = state as PhoneFormFieldState;
            return PhoneField(
              controller: field._childController,
              showFlagInInput: showFlagInInput,
              selectorNavigator: countrySelectorNavigator,
              errorText: field.getErrorText(),
              flagSize: flagSize,
              decoration: decoration,
              enabled: enabled,
              isCountrySelectionEnabled: isCountrySelectionEnabled,
              isCountryChipPersistent: isCountryChipPersistent,
              // textfield params
              autofillHints: autofillHints,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              countryCodeStyle: countryCodeStyle,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              autofocus: autofocus,
              obscuringCharacter: obscuringCharacter,
              obscureText: obscureText,
              autocorrect: autocorrect,
              smartDashesType: smartDashesType,
              smartQuotesType: smartQuotesType,
              enableSuggestions: enableSuggestions,
              toolbarContextMenuBuilder: toolbarContextMenuBuilder,
              showCursor: showCursor,
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
              onAppPrivateCommand: onAppPrivateCommand,
              cursorWidth: cursorWidth,
              cursorHeight: cursorHeight,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              selectionHeightStyle: selectionHeightStyle,
              selectionWidthStyle: selectionWidthStyle,
              keyboardAppearance: keyboardAppearance,
              scrollPadding: scrollPadding,
              enableInteractiveSelection: enableInteractiveSelection,
              selectionControls: selectionControls,
              mouseCursor: mouseCursor,
              scrollController: scrollController,
              scrollPhysics: scrollPhysics,
              restorationId: restorationId,
              enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
              inputFormatters: inputFormatters,
            );
          },
        );

  /// {@macro controller}
  final PhoneController? controller;

  /// {@macro shouldFormat}
  final bool shouldFormat;

  /// callback called when the input value changes
  final ValueChanged<PhoneNumber?>? onChanged;

  /// country that is displayed when there is no value
  final IsoCode defaultCountry;

  /// the focusNode of the national number
  final FocusNode? focusNode;

  @override
  PhoneFormFieldState createState() => PhoneFormFieldState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<PhoneController?>('controller', controller))
      ..add(DiagnosticsProperty<bool>('shouldFormat', shouldFormat))
      ..add(
        ObjectFlagProperty<ValueChanged<PhoneNumber?>?>.has(
          'onChanged',
          onChanged,
        ),
      )
      ..add(EnumProperty<IsoCode>('defaultCountry', defaultCountry))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
  }
}
