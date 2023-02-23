import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/widgets/country_selector/country_list.dart';

void main() {
  group('PhoneFormField', () {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final GlobalKey<FormFieldState<PhoneNumber>> phoneKey =
        GlobalKey<FormFieldState<PhoneNumber>>();
    Widget getWidget({
      final Function(PhoneNumber?)? onChanged,
      final Function(PhoneNumber?)? onSaved,
      final PhoneNumber? initialValue,
      final PhoneController? controller,
      final bool showFlagInInput = true,
      final IsoCode defaultCountry = IsoCode.US,
      final bool shouldFormat = false,
      final PhoneNumberInputValidator? validator,
    }) =>
        MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            PhoneFieldLocalization.delegate,
          ],
          supportedLocales: const <Locale>[Locale('en')],
          home: Scaffold(
            body: Form(
              key: formKey,
              child: PhoneFormField(
                key: phoneKey,
                initialValue: initialValue,
                onChanged: onChanged,
                onSaved: onSaved,
                showFlagInInput: showFlagInInput,
                controller: controller,
                defaultCountry: defaultCountry,
                shouldFormat: shouldFormat,
                validator: validator,
              ),
            ),
          ),
        );

    group('display', () {
      testWidgets('Should display input', (final WidgetTester tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('Should display country code',
          (final WidgetTester tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(CountryCodeChip), findsWidgets);
      });

      testWidgets('Should display flag', (final WidgetTester tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(CircleFlag), findsWidgets);
      });
    });

    group('Country code', () {
      testWidgets('Should open dialog when country code is clicked',
          (final WidgetTester tester) async {
        await tester.pumpWidget(getWidget());
        expect(find.byType(CountryList), findsNothing);
        await tester.tap(find.byType(PhoneFormField));
        await tester.pump(const Duration(seconds: 1));
        await tester.tap(find.byType(CountryCodeChip));
        await tester.pumpAndSettle();
        expect(find.byType(CountryList), findsOneWidget);
      });
      testWidgets('Should have a default country',
          (final WidgetTester tester) async {
        await tester.pumpWidget(getWidget(defaultCountry: IsoCode.FR));
        expect(find.text('+ 33'), findsWidgets);
      });

      testWidgets('Should hide flag', (final WidgetTester tester) async {
        await tester.pumpWidget(getWidget(showFlagInInput: false));
        expect(find.byType(CircleFlag), findsNothing);
      });
    });

    group('value changes', () {
      testWidgets('Should display initial value',
          (final WidgetTester tester) async {
        await tester.pumpWidget(
          getWidget(
            initialValue: PhoneNumber.parse(
              '478787827',
              destinationCountry: IsoCode.FR,
            ),
          ),
        );
        expect(find.text('+ 33'), findsWidgets);
        expect(find.text('478787827'), findsOneWidget);
      });

      testWidgets('Should change value of controller',
          (final WidgetTester tester) async {
        final PhoneController controller = PhoneController(null);
        PhoneNumber? newValue;
        controller.addListener(() {
          newValue = controller.value;
        });
        await tester.pumpWidget(
          getWidget(controller: controller),
        );
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.tap(phoneField);
        // non digits should not work
        await tester.enterText(phoneField, '123456789');
        expect(
          newValue,
          equals(
            PhoneNumber.parse(
              '123456789',
              destinationCountry: IsoCode.US,
            ),
          ),
        );
      });

      testWidgets('Should change value of input when controller changes',
          (final WidgetTester tester) async {
        final PhoneController controller = PhoneController(null);
        // ignore: unused_local_variable
        PhoneNumber? newValue;
        controller.addListener(() {
          newValue = controller.value;
        });
        await tester.pumpWidget(
          getWidget(controller: controller),
        );
        controller.value =
            PhoneNumber.parse('488997722', destinationCountry: IsoCode.FR);
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('+ 33'), findsWidgets);
        expect(find.text('488997722'), findsOneWidget);
      });
      testWidgets(
          'Should change value of country code chip when full number copy pasted',
          (final WidgetTester tester) async {
        final PhoneController controller = PhoneController(null);
        // ignore: unused_local_variable
        PhoneNumber? newValue;
        controller.addListener(() {
          newValue = controller.value;
        });
        await tester.pumpWidget(
          getWidget(controller: controller),
        );
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.tap(phoneField);
        // non digits should not work
        await tester.enterText(phoneField, '+33 0488 99 77 22');
        await tester.pump();
        expect(controller.value?.isoCode, equals(IsoCode.FR));
        expect(controller.value?.nsn, equals('488997722'));
      });

      testWidgets('Should call onChange', (final WidgetTester tester) async {
        bool changed = false;
        PhoneNumber? phoneNumber =
            PhoneNumber.parse('', destinationCountry: IsoCode.FR);
        void onChanged(final PhoneNumber? p) {
          changed = true;
          phoneNumber = p;
        }

        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            onChanged: onChanged,
          ),
        );
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.tap(phoneField);
        // non digits should not work
        await tester.enterText(phoneField, 'aaa');
        await tester.pump(const Duration(seconds: 1));
        expect(changed, equals(false));
        await tester.enterText(phoneField, '123');
        await tester.pump(const Duration(seconds: 1));
        expect(changed, equals(true));
        expect(
          phoneNumber,
          equals(PhoneNumber.parse('123', destinationCountry: IsoCode.FR)),
        );
      });
    });

    group('validity', () {
      testWidgets('Should tell when a phone number is not valid',
          (final WidgetTester tester) async {
        final PhoneNumber phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );
        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '9984');
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Invalid phone number'), findsOneWidget);
      });

      testWidgets(
          'Should tell when a phone number is not valid for a given phone number type',
          (final WidgetTester tester) async {
        final PhoneNumber phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.BE,
        );
        // valid fixed line
        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            validator: PhoneValidator.validFixedLine(),
          ),
        );
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '77777777');
        await tester.pumpAndSettle();
        expect(find.text('Invalid'), findsNothing);
        // invalid mobile
        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            validator: PhoneValidator.validMobile(
              errorText: 'Invalid phone number',
            ),
          ),
        );
        final Finder phoneField2 = find.byType(PhoneFormField);
        await tester.pumpAndSettle();
        await tester.enterText(phoneField2, '77777777');
        await tester.pumpAndSettle();
        expect(find.text('Invalid phone number'), findsOneWidget);

        // valid mobile
        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            validator: PhoneValidator.validMobile(
              errorText: 'Invalid phone number',
            ),
          ),
        );
        final Finder phoneField3 = find.byType(PhoneFormField);
        await tester.enterText(phoneField3, '477668899');
        await tester.pumpAndSettle();
        expect(find.text('Invalid'), findsNothing);
      });
    });

    group('Format', () {
      testWidgets('Should format when shouldFormat is true',
          (final WidgetTester tester) async {
        final PhoneNumber phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );

        await tester.pumpWidget(
          getWidget(initialValue: phoneNumber, shouldFormat: true),
        );
        await tester.pump(const Duration(seconds: 1));
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '677777777');
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('6 77 77 77 77'), findsOneWidget);
      });
      testWidgets('Should not format when shouldFormat is false',
          (final WidgetTester tester) async {
        final PhoneNumber phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );

        await tester.pumpWidget(
          getWidget(initialValue: phoneNumber),
        );
        await tester.pump(const Duration(seconds: 1));
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '677777777');
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('677777777'), findsOneWidget);
      });
    });

    group('form field', () {
      testWidgets('Should call onSaved', (final WidgetTester tester) async {
        bool saved = false;
        PhoneNumber? phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );
        void onSaved(final PhoneNumber? p) {
          saved = true;
          phoneNumber = p;
        }

        await tester.pumpWidget(
          getWidget(
            initialValue: phoneNumber,
            onSaved: onSaved,
          ),
        );
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, '479281938');
        await tester.pump(const Duration(seconds: 1));
        formKey.currentState?.save();
        await tester.pump(const Duration(seconds: 1));
        expect(saved, isTrue);
        expect(
          phoneNumber,
          equals(
            PhoneNumber.parse(
              '479281938',
              destinationCountry: IsoCode.FR,
            ),
          ),
        );
      });

      testWidgets('Should reset', (final WidgetTester tester) async {
        final PhoneNumber phoneNumber = PhoneNumber.parse(
          '',
          destinationCountry: IsoCode.FR,
        );

        await tester.pumpWidget(getWidget(initialValue: phoneNumber));
        await tester.pump(const Duration(seconds: 1));
        const String national = '123456';
        final Finder phoneField = find.byType(PhoneFormField);
        await tester.enterText(phoneField, national);
        expect(find.text(national), findsOneWidget);
        formKey.currentState?.reset();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text(national), findsNothing);
      });
    });

    group('Directionality', () {
      testWidgets('Using textDirection.LTR on RTL context',
          (final WidgetTester tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.rtl,
            child: getWidget(),
          ),
        );
        final Finder finder = find.byType(Directionality);
        final Directionality widget =
            finder.at(1).evaluate().single.widget as Directionality;
        expect(widget.textDirection, TextDirection.ltr);
      });
    });
  });
}
