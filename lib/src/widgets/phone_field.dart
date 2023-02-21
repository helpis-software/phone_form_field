import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/patterns.dart';
import 'package:phone_form_field/src/models/phone_field_controller.dart';

import '../../phone_form_field.dart';

part 'phone_field_state.dart';

/// Phone field
///
/// This deals with mostly UI and has no dependency on any phone parser library
class PhoneField extends StatefulWidget {
  const PhoneField({
    required this.controller,
    required this.showFlagInInput,
    required this.selectorNavigator,
    required this.flagSize,
    required this.errorText,
    required this.decoration,
    required this.isCountrySelectionEnabled,
    required this.isCountryChipPersistent, // textfield  inputs
    required this.keyboardType,
    required this.textInputAction,
    required this.style,
    required this.countryCodeStyle,
    required this.strutStyle,
    required this.textAlign,
    required this.textAlignVertical,
    required this.autofocus,
    required this.obscuringCharacter,
    required this.obscureText,
    required this.autocorrect,
    required this.smartDashesType,
    required this.smartQuotesType,
    required this.enableSuggestions,
    required this.toolbarContextMenuBuilder,
    required this.showCursor,
    required this.onEditingComplete,
    required this.onSubmitted,
    required this.onAppPrivateCommand,
    required this.enabled,
    required this.cursorWidth,
    required this.cursorHeight,
    required this.cursorRadius,
    required this.cursorColor,
    required this.selectionHeightStyle,
    required this.selectionWidthStyle,
    required this.keyboardAppearance,
    required this.scrollPadding,
    required this.enableInteractiveSelection,
    required this.selectionControls,
    required this.mouseCursor,
    required this.scrollPhysics,
    required this.scrollController,
    required this.autofillHints,
    required this.restorationId,
    required this.enableIMEPersonalizedLearning,
    required this.inputFormatters, // form field params
    super.key,
  });
  final PhoneFieldController controller;
  final bool showFlagInInput;
  final String? errorText;
  final double flagSize;
  final InputDecoration decoration;
  final bool isCountrySelectionEnabled;
  final bool isCountryChipPersistent;

  /// configures the way the country picker selector is shown
  final CountrySelectorNavigator selectorNavigator;

  // textfield inputs
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? countryCodeStyle;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final EditableTextContextMenuBuilder? toolbarContextMenuBuilder;
  final bool? showCursor;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  bool get selectionEnabled => enableInteractiveSelection;
  final MouseCursor? mouseCursor;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final List<TextInputFormatter>? inputFormatters;

  @override
  PhoneFieldState createState() => PhoneFieldState();
  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<PhoneFieldController>('controller', controller),
      )
      ..add(
        IterableProperty<TextInputFormatter>(
          'inputFormatters',
          inputFormatters,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>(
          'enableIMEPersonalizedLearning',
          enableIMEPersonalizedLearning,
        ),
      )
      ..add(StringProperty('restorationId', restorationId))
      ..add(IterableProperty<String>('autofillHints', autofillHints))
      ..add(
        DiagnosticsProperty<ScrollController?>(
          'scrollController',
          scrollController,
        ),
      )
      ..add(
        DiagnosticsProperty<ScrollPhysics?>('scrollPhysics', scrollPhysics),
      )
      ..add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor))
      ..add(DiagnosticsProperty<bool>('selectionEnabled', selectionEnabled))
      ..add(
        DiagnosticsProperty<TextSelectionControls?>(
          'selectionControls',
          selectionControls,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>(
          'enableInteractiveSelection',
          enableInteractiveSelection,
        ),
      )
      ..add(DiagnosticsProperty<EdgeInsets>('scrollPadding', scrollPadding))
      ..add(
        EnumProperty<Brightness?>('keyboardAppearance', keyboardAppearance),
      )
      ..add(
        EnumProperty<ui.BoxWidthStyle>(
          'selectionWidthStyle',
          selectionWidthStyle,
        ),
      )
      ..add(
        EnumProperty<ui.BoxHeightStyle>(
          'selectionHeightStyle',
          selectionHeightStyle,
        ),
      )
      ..add(ColorProperty('cursorColor', cursorColor))
      ..add(DiagnosticsProperty<Radius?>('cursorRadius', cursorRadius))
      ..add(DoubleProperty('cursorHeight', cursorHeight))
      ..add(DoubleProperty('cursorWidth', cursorWidth))
      ..add(DiagnosticsProperty<bool?>('enabled', enabled))
      ..add(
        ObjectFlagProperty<AppPrivateCommandCallback?>.has(
          'onAppPrivateCommand',
          onAppPrivateCommand,
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<String>?>.has(
          'onSubmitted',
          onSubmitted,
        ),
      )
      ..add(
        ObjectFlagProperty<VoidCallback?>.has(
          'onEditingComplete',
          onEditingComplete,
        ),
      )
      ..add(DiagnosticsProperty<bool?>('showCursor', showCursor))
      ..add(DiagnosticsProperty<bool>('enableSuggestions', enableSuggestions))
      ..add(
        EnumProperty<SmartQuotesType?>('smartQuotesType', smartQuotesType),
      )
      ..add(
        EnumProperty<SmartDashesType?>('smartDashesType', smartDashesType),
      )
      ..add(DiagnosticsProperty<bool>('autocorrect', autocorrect))
      ..add(DiagnosticsProperty<bool>('obscureText', obscureText))
      ..add(StringProperty('obscuringCharacter', obscuringCharacter))
      ..add(DiagnosticsProperty<bool>('autofocus', autofocus))
      ..add(
        DiagnosticsProperty<TextAlignVertical?>(
          'textAlignVertical',
          textAlignVertical,
        ),
      )
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(DiagnosticsProperty<StrutStyle?>('strutStyle', strutStyle))
      ..add(
        DiagnosticsProperty<TextStyle?>('countryCodeStyle', countryCodeStyle),
      )
      ..add(DiagnosticsProperty<TextStyle?>('style', style))
      ..add(
        EnumProperty<TextInputAction?>('textInputAction', textInputAction),
      )
      ..add(DiagnosticsProperty<TextInputType>('keyboardType', keyboardType))
      ..add(
        DiagnosticsProperty<CountrySelectorNavigator>(
          'selectorNavigator',
          selectorNavigator,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>(
          'isCountryChipPersistent',
          isCountryChipPersistent,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>(
          'isCountrySelectionEnabled',
          isCountrySelectionEnabled,
        ),
      )
      ..add(DiagnosticsProperty<InputDecoration>('decoration', decoration))
      ..add(DoubleProperty('flagSize', flagSize))
      ..add(StringProperty('errorText', errorText))
      ..add(DiagnosticsProperty<bool>('showFlagInInput', showFlagInInput))
      ..add(
        ObjectFlagProperty<EditableTextContextMenuBuilder?>.has(
          'toolbarContextMenuBuilder',
          toolbarContextMenuBuilder,
        ),
      );
  }
}
