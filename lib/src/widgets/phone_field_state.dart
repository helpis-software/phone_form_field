part of 'phone_field.dart';

class PhoneFieldState extends State<PhoneField> {
  PhoneFieldController get controller => widget.controller;

  PhoneFieldState();

  @override
  void initState() {
    controller.focusNode.addListener(onFocusChange);
    super.initState();
  }

  void onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.focusNode.removeListener(onFocusChange);
    super.dispose();
  }

  void selectCountry() async {
    if (!widget.isCountrySelectionEnabled) {
      return;
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final selected = await widget.selectorNavigator.navigate(context);
    if (selected != null) {
      controller.isoCode = selected.isoCode;
    }
    controller.focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  Widget build(BuildContext context) {
    // the idea here is to have a mouse region that surround every thing
    // that has a text cursor.
    // When the country chip is not shown it request focus.
    // When the country chip is shown, clicking on it request country selection
    return Stack(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.text,
          child: GestureDetector(
            onTap: controller.focusNode.requestFocus,
            child: AbsorbPointer(
              // absorb pointer when the country chip is not shown, else flutter
              // still allows the country chip to be clicked even though it is not shown
              absorbing:
                  _isEffectivelyEmpty() && !controller.focusNode.hasFocus,
              child: InputDecorator(
                decoration: _getOutterInputDecoration(),
                isFocused: controller.focusNode.hasFocus,
                isEmpty: _isEffectivelyEmpty(),
                child: TextField(
                  focusNode: controller.focusNode,
                  controller: controller.nationalNumberController,
                  enabled: widget.enabled,
                  decoration: _getInnerInputDecoration(),
                  inputFormatters: widget.inputFormatters ??
                      [
                        FilteringTextInputFormatter.allow(RegExp(
                            '[${Patterns.plus}${Patterns.digits}${Patterns.punctuation}]')),
                      ],
                  autofillHints: widget.autofillHints,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  style: widget.style,
                  strutStyle: widget.strutStyle,
                  textAlign: widget.textAlign,
                  textAlignVertical: widget.textAlignVertical,
                  autofocus: widget.autofocus,
                  obscuringCharacter: widget.obscuringCharacter,
                  obscureText: widget.obscureText,
                  autocorrect: widget.autocorrect,
                  smartDashesType: widget.smartDashesType,
                  smartQuotesType: widget.smartQuotesType,
                  enableSuggestions: widget.enableSuggestions,
                  contextMenuBuilder: widget.contextMenuBuilder,
                  showCursor: widget.showCursor,
                  onEditingComplete: widget.onEditingComplete,
                  onSubmitted: widget.onSubmitted,
                  onAppPrivateCommand: widget.onAppPrivateCommand,
                  cursorWidth: widget.cursorWidth,
                  cursorHeight: widget.cursorHeight,
                  cursorRadius: widget.cursorRadius,
                  cursorColor: widget.cursorColor,
                  selectionHeightStyle: widget.selectionHeightStyle,
                  selectionWidthStyle: widget.selectionWidthStyle,
                  keyboardAppearance: widget.keyboardAppearance,
                  scrollPadding: widget.scrollPadding,
                  enableInteractiveSelection: widget.enableInteractiveSelection,
                  selectionControls: widget.selectionControls,
                  mouseCursor: widget.mouseCursor,
                  scrollController: widget.scrollController,
                  scrollPhysics: widget.scrollPhysics,
                  restorationId: widget.restorationId,
                  enableIMEPersonalizedLearning:
                      widget.enableIMEPersonalizedLearning,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: constraints.maxWidth,
                  width:
                      (widget.decoration.contentPadding?.horizontal ?? 10) + 20,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: selectCountry,
                      child: SizedBox(
                        height: constraints.maxWidth,
                        width: (widget.decoration.contentPadding?.horizontal ??
                                10) +
                            20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getCountryCodeChip() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: selectCountry,
          // material here else the click pass through empty spaces
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              child: CountryCodeChip(
                key: const ValueKey('country-code-chip'),
                isoCode: controller.isoCode,
                showFlag: widget.showFlagInInput,
                textStyle: widget.countryCodeStyle ??
                    widget.decoration.labelStyle ??
                    TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                flagSize: widget.flagSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getInnerInputDecoration() {
    return InputDecoration.collapsed(
      hintText: widget.decoration.hintText,
      hintStyle: widget.decoration.hintStyle,
    ).copyWith(
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      errorStyle: widget.decoration.errorStyle,
    );
  }

  InputDecoration _getOutterInputDecoration() {
    final directionality = Directionality.of(context);

    return widget.decoration.copyWith(
      hintText: null,
      errorText: widget.errorText,
      prefix:
          directionality == TextDirection.ltr ? _getCountryCodeChip() : null,
      suffix:
          directionality == TextDirection.rtl ? _getCountryCodeChip() : null,
      errorStyle: widget.decoration.errorStyle,
    );
  }

  bool _isEffectivelyEmpty() {
    if (widget.isCountryChipPersistent) return false;
    final outterDecoration = _getOutterInputDecoration();
    // when there is not label and an hint text we need to have
    // isEmpty false so the country code is displayed along the
    // hint text to not have the hint text in the middle
    if (outterDecoration.label == null && outterDecoration.hintText != null) {
      return false;
    }
    return controller.nationalNumberController.text.isEmpty;
  }
}
