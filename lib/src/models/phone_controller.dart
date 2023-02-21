import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneController extends ValueNotifier<PhoneNumber?> {
  PhoneController(this.initialValue) : super(initialValue);
  final PhoneNumber? initialValue;
  // when we want to select the national number
  final StreamController<void> _selectionRequestController =
      StreamController<void>.broadcast();
  Stream<void> get selectionRequestStream => _selectionRequestController.stream;

  void selectNationalNumber() => _selectionRequestController.add(null);

  void reset() => value = null;

  @override
  void dispose() {
    unawaited(_selectionRequestController.close());
    super.dispose();
  }
}
