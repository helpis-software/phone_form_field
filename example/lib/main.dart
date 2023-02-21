import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  runApp(const MyApp());
}

// this example makes uses of lots of properties that would not be there
// in a real scenario for the sake of showing the features.
// For a simpler example see the README

class PhoneFieldView extends StatelessWidget {
  const PhoneFieldView({
    required this.inputKey,
    required this.controller,
    required this.selectorNavigator,
    required this.withLabel,
    required this.outlineBorder,
    required this.shouldFormat,
    required this.isCountryChipPersistent,
    required this.mobileOnly,
    required this.useRtl,
    super.key,
  });
  final Key inputKey;
  final PhoneController controller;
  final CountrySelectorNavigator selectorNavigator;
  final bool withLabel;
  final bool outlineBorder;
  final bool shouldFormat;
  final bool isCountryChipPersistent;
  final bool mobileOnly;
  final bool useRtl;

  PhoneNumberInputValidator? _getValidator() {
    final List<PhoneNumberInputValidator> validators =
        <PhoneNumberInputValidator>[];
    if (mobileOnly) {
      validators.add(PhoneValidator.validMobile());
    } else {
      validators.add(PhoneValidator.valid());
    }
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  @override
  Widget build(final BuildContext context) => AutofillGroup(
        child: Directionality(
          textDirection: useRtl ? TextDirection.rtl : TextDirection.ltr,
          child: PhoneFormField(
            key: inputKey,
            controller: controller,
            shouldFormat: shouldFormat && !useRtl,
            autofocus: true,
            autofillHints: const <String>[AutofillHints.telephoneNumber],
            countrySelectorNavigator: selectorNavigator,
            decoration: InputDecoration(
              label: withLabel ? const Text('Phone') : null,
              border: outlineBorder
                  ? const OutlineInputBorder()
                  : const UnderlineInputBorder(),
              hintText: withLabel ? '' : 'Phone',
            ),
            validator: _getValidator(),
            cursorColor: Theme.of(context).colorScheme.primary,
            // ignore: avoid_print
            onSaved: (final PhoneNumber? p) => print('saved $p'),
            // ignore: avoid_print
            onChanged: (final PhoneNumber? p) => print('changed $p'),
            isCountryChipPersistent: isCountryChipPersistent,
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Key>('inputKey', inputKey))
      ..add(DiagnosticsProperty<bool>('useRtl', useRtl))
      ..add(DiagnosticsProperty<bool>('mobileOnly', mobileOnly))
      ..add(
        DiagnosticsProperty<bool>(
          'isCountryChipPersistent',
          isCountryChipPersistent,
        ),
      )
      ..add(DiagnosticsProperty<bool>('shouldFormat', shouldFormat))
      ..add(DiagnosticsProperty<bool>('outlineBorder', outlineBorder))
      ..add(DiagnosticsProperty<bool>('withLabel', withLabel))
      ..add(
        DiagnosticsProperty<CountrySelectorNavigator>(
          'selectorNavigator',
          selectorNavigator,
        ),
      )
      ..add(DiagnosticsProperty<PhoneController>('controller', controller));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          ...GlobalMaterialLocalizations.delegates,
          PhoneFieldLocalization.delegate
        ],
        supportedLocales: const <Locale>[
          Locale('en', ''),
          Locale('fr', ''),
          Locale('es', ''),
          Locale('el', ''),
          Locale('de', ''),
          Locale('it', ''),
          Locale('ru', ''),
          Locale('sv', ''),
          Locale('tr', ''),
          Locale('zh', ''),
          // ...
        ],
        title: 'Phone field demo',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        ),
        home: const PhoneFormFieldScreen(),
      );
}

class PhoneFormFieldScreen extends StatefulWidget {
  const PhoneFormFieldScreen({super.key});

  @override
  PhoneFormFieldScreenState createState() => PhoneFormFieldScreenState();
}

class PhoneFormFieldScreenState extends State<PhoneFormFieldScreen> {
  late PhoneController controller;
  bool outlineBorder = true;
  bool mobileOnly = true;
  bool shouldFormat = true;
  bool isCountryChipPersistent = false;
  bool withLabel = true;
  bool useRtl = false;
  CountrySelectorNavigator selectorNavigator =
      const CountrySelectorNavigator.searchDelegate();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<PhoneNumber>> phoneKey =
      GlobalKey<FormFieldState<PhoneNumber>>();

  @override
  void initState() {
    super.initState();
    controller = PhoneController(null);
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        // drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('Phone_form_field'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        value: outlineBorder,
                        onChanged: (final bool v) =>
                            setState(() => outlineBorder = v),
                        title: const Text('Outlined border'),
                      ),
                      SwitchListTile(
                        value: withLabel,
                        onChanged: (final bool v) =>
                            setState(() => withLabel = v),
                        title: const Text('Label'),
                      ),
                      SwitchListTile(
                        value: isCountryChipPersistent,
                        onChanged: (final bool v) =>
                            setState(() => isCountryChipPersistent = v),
                        title: const Text('Persistent country chip'),
                      ),
                      SwitchListTile(
                        value: mobileOnly,
                        onChanged: (final bool v) =>
                            setState(() => mobileOnly = v),
                        title: const Text('Mobile phone number only'),
                      ),
                      SwitchListTile(
                        value: shouldFormat,
                        onChanged: (final bool v) =>
                            setState(() => shouldFormat = v),
                        title: const Text('Should format'),
                      ),
                      SwitchListTile(
                        value: useRtl,
                        onChanged: (final bool v) {
                          setState(() => useRtl = v);
                        },
                        title: const Text('RTL'),
                      ),
                      ListTile(
                        title: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            const Text('Country selector: '),
                            DropdownButton<CountrySelectorNavigator>(
                              value: selectorNavigator,
                              onChanged:
                                  (final CountrySelectorNavigator? value) {
                                if (value != null) {
                                  setState(() => selectorNavigator = value);
                                }
                              },
                              items: const <
                                  DropdownMenuItem<CountrySelectorNavigator>>[
                                DropdownMenuItem<CountrySelectorNavigator>(
                                  value: CountrySelectorNavigator.bottomSheet(),
                                  child: Text('Bottom sheet'),
                                ),
                                DropdownMenuItem<CountrySelectorNavigator>(
                                  value: CountrySelectorNavigator
                                      .draggableBottomSheet(),
                                  child: Text('Draggable modal sheet'),
                                ),
                                DropdownMenuItem<CountrySelectorNavigator>(
                                  value:
                                      CountrySelectorNavigator.modalBottomSheet(
                                    favorites: <IsoCode>[
                                      IsoCode.US,
                                      IsoCode.BE
                                    ],
                                  ),
                                  child: Text('Modal sheet'),
                                ),
                                DropdownMenuItem<CountrySelectorNavigator>(
                                  value: CountrySelectorNavigator.dialog(
                                    width: 720,
                                  ),
                                  child: Text('Dialog'),
                                ),
                                DropdownMenuItem<CountrySelectorNavigator>(
                                  value:
                                      CountrySelectorNavigator.searchDelegate(),
                                  child: Text('Page'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: formKey,
                        child: PhoneFieldView(
                          inputKey: phoneKey,
                          controller: controller,
                          selectorNavigator: selectorNavigator,
                          withLabel: withLabel,
                          outlineBorder: outlineBorder,
                          isCountryChipPersistent: isCountryChipPersistent,
                          mobileOnly: mobileOnly,
                          shouldFormat: shouldFormat,
                          useRtl: useRtl,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(controller.value.toString()),
                      Text(
                        'is valid mobile number '
                        '${controller.value?.isValid(type: PhoneNumberType.mobile) ?? 'false'}',
                      ),
                      Text(
                        'is valid fixed line number ${controller.value?.isValid(type: PhoneNumberType.fixedLine) ?? 'false'}',
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: controller.value == null
                            ? null
                            : () => controller.reset(),
                        child: const Text('reset'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => controller.selectNationalNumber(),
                        child: const Text('Select national number'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => controller.value = PhoneNumber.parse(
                          '699999999',
                          destinationCountry: IsoCode.FR,
                        ),
                        child: const Text('Set +33 699 999 999'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<PhoneController>('controller', controller))
      ..add(
        DiagnosticsProperty<GlobalKey<FormFieldState<PhoneNumber>>>(
          'phoneKey',
          phoneKey,
        ),
      )
      ..add(DiagnosticsProperty<GlobalKey<FormState>>('formKey', formKey))
      ..add(
        DiagnosticsProperty<CountrySelectorNavigator>(
          'selectorNavigator',
          selectorNavigator,
        ),
      )
      ..add(DiagnosticsProperty<bool>('useRtl', useRtl))
      ..add(DiagnosticsProperty<bool>('withLabel', withLabel))
      ..add(
        DiagnosticsProperty<bool>(
          'isCountryChipPersistent',
          isCountryChipPersistent,
        ),
      )
      ..add(DiagnosticsProperty<bool>('shouldFormat', shouldFormat))
      ..add(DiagnosticsProperty<bool>('mobileOnly', mobileOnly))
      ..add(DiagnosticsProperty<bool>('outlineBorder', outlineBorder));
  }
}
