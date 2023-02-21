import 'package:flutter/material.dart';
import 'package:phone_form_field/src/models/iso_code.dart';

class PhoneFieldController extends ChangeNotifier {
  PhoneFieldController({
    required final String? national,
    required final IsoCode isoCode,
    required this.focusNode,
  }) {
    isoCodeController = ValueNotifier<IsoCode>(isoCode);
    nationalNumberController = TextEditingController(text: national);
    isoCodeController.addListener(notifyListeners);
    nationalNumberController.addListener(notifyListeners);
  }
  late final ValueNotifier<IsoCode> isoCodeController;
  late final TextEditingController nationalNumberController;

  /// focus node of the national number
  final FocusNode focusNode;

  IsoCode get isoCode => isoCodeController.value;
  String? get national => nationalNumberController.text;

  set isoCode(final IsoCode isoCode) => isoCodeController.value = isoCode;

  set national(final String? national) {
    final String national0 = national ?? '';
    final int currentSelectionOffset =
        nationalNumberController.selection.extentOffset;
    final bool isCursorAtEnd =
        currentSelectionOffset == nationalNumberController.text.length;
    int offset = national0.length;

    if (isCursorAtEnd) {
      offset = national0.length;
    } else if (currentSelectionOffset <= national0.length) {
      offset = currentSelectionOffset;
    }
    // when the cursor is at the end we need to preserve that
    // since there is formatting going on we need to explicitely do it
    nationalNumberController.value = TextEditingValue(
      text: national0,
      selection: TextSelection.fromPosition(
        TextPosition(offset: offset),
      ),
    );
  }

  void selectNationalNumber() {
    nationalNumberController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: nationalNumberController.value.text.length,
    );
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    isoCodeController.dispose();
    nationalNumberController.dispose();
    super.dispose();
  }
}
