import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/widgets/country_selector/country_selector_page.dart';

abstract class CountrySelectorNavigator {
  const CountrySelectorNavigator({
    required this.searchAutofocus,
    this.countries,
    this.favorites,
    this.addSeparator = true,
    this.showCountryCode = true,
    this.sortCountries = false,
    this.noResultMessage,
    this.subtitleStyle,
    this.titleStyle,
    this.searchBoxDecoration,
    this.searchBoxTextStyle,
    this.searchBoxIconColor,
    this.scrollPhysics,
    this.flagSize = 40,
    this.useRootNavigator = true,
  });

  const factory CountrySelectorNavigator.dialog({
    final double? height,
    final double? width,
    final List<IsoCode>? countries,
    final List<IsoCode>? favorites,
    final bool addSeparator,
    final bool showCountryCode,
    final bool sortCountries,
    final String? noResultMessage,
    final bool searchAutofocus,
    final TextStyle? subtitleStyle,
    final TextStyle? titleStyle,
    final InputDecoration? searchBoxDecoration,
    final TextStyle? searchBoxTextStyle,
    final Color? searchBoxIconColor,
    final ScrollPhysics? scrollPhysics,
  }) = DialogNavigator._;

  const factory CountrySelectorNavigator.searchDelegate({
    final List<IsoCode>? countries,
    final List<IsoCode>? favorites,
    final bool addSeparator,
    final bool showCountryCode,
    final bool sortCountries,
    final String? noResultMessage,
    final bool searchAutofocus,
    final TextStyle? subtitleStyle,
    final TextStyle? titleStyle,
    final InputDecoration? searchBoxDecoration,
    final TextStyle? searchBoxTextStyle,
    final Color? searchBoxIconColor,
    final ScrollPhysics? scrollPhysics,
  }) = SearchDelegateNavigator._;

  const factory CountrySelectorNavigator.bottomSheet({
    final List<IsoCode>? countries,
    final List<IsoCode>? favorites,
    final bool addSeparator,
    final bool showCountryCode,
    final bool sortCountries,
    final String? noResultMessage,
    final bool searchAutofocus,
    final TextStyle? subtitleStyle,
    final TextStyle? titleStyle,
    final InputDecoration? searchBoxDecoration,
    final TextStyle? searchBoxTextStyle,
    final Color? searchBoxIconColor,
    final ScrollPhysics? scrollPhysics,
  }) = BottomSheetNavigator._;

  const factory CountrySelectorNavigator.modalBottomSheet({
    final double? height,
    final List<IsoCode>? countries,
    final List<IsoCode>? favorites,
    final bool addSeparator,
    final bool showCountryCode,
    final bool sortCountries,
    final String? noResultMessage,
    final bool searchAutofocus,
    final TextStyle? subtitleStyle,
    final TextStyle? titleStyle,
    final InputDecoration? searchBoxDecoration,
    final TextStyle? searchBoxTextStyle,
    final Color? searchBoxIconColor,
    final ScrollPhysics? scrollPhysics,
  }) = ModalBottomSheetNavigator._;

  const factory CountrySelectorNavigator.draggableBottomSheet({
    final double initialChildSize,
    final double minChildSize,
    final double maxChildSize,
    final BorderRadiusGeometry? borderRadius,
    final List<IsoCode>? countries,
    final List<IsoCode>? favorites,
    final bool addSeparator,
    final bool showCountryCode,
    final double flagSize,
    final bool sortCountries,
    final String? noResultMessage,
    final bool searchAutofocus,
    final TextStyle? subtitleStyle,
    final TextStyle? titleStyle,
    final InputDecoration? searchBoxDecoration,
    final TextStyle? searchBoxTextStyle,
    final Color? searchBoxIconColor,
    final ScrollPhysics? scrollPhysics,
  }) = DraggableModalBottomSheetNavigator._;
  final List<IsoCode>? countries;
  final List<IsoCode>? favorites;
  final bool addSeparator;
  final bool showCountryCode;
  final bool sortCountries;
  final String? noResultMessage;
  final bool searchAutofocus;
  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;
  final InputDecoration? searchBoxDecoration;
  final TextStyle? searchBoxTextStyle;
  final Color? searchBoxIconColor;
  final ScrollPhysics? scrollPhysics;
  final double flagSize;
  final bool useRootNavigator;

  Future<Country?> navigate(final BuildContext context);

  CountrySelector _getCountrySelector({
    required final ValueChanged<Country> onCountrySelected,
    final ScrollController? scrollController,
  }) =>
      CountrySelector(
        countries: countries,
        onCountrySelected: onCountrySelected,
        favoriteCountries: favorites ?? <IsoCode>[],
        addFavoritesSeparator: addSeparator,
        showCountryCode: showCountryCode,
        noResultMessage: noResultMessage,
        scrollController: scrollController,
        searchAutofocus: searchAutofocus,
        subtitleStyle: subtitleStyle,
        titleStyle: titleStyle,
        searchBoxDecoration: searchBoxDecoration,
        searchBoxTextStyle: searchBoxTextStyle,
        searchBoxIconColor: searchBoxIconColor,
        scrollPhysics: scrollPhysics,
        flagSize: flagSize,
      );
}

class DialogNavigator extends CountrySelectorNavigator {
  const DialogNavigator._({
    this.width,
    this.height,
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showCountryCode,
    super.sortCountries,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
  });
  final double? height;
  final double? width;

  @override
  Future<Country?> navigate(final BuildContext context) => showDialog(
        context: context,
        builder: (final _) => Dialog(
          child: SizedBox(
            width: width,
            height: height,
            child: _getCountrySelector(
              onCountrySelected: (final Country country) =>
                  Navigator.of(context, rootNavigator: true).pop(country),
            ),
          ),
        ),
      );
}

class SearchDelegateNavigator extends CountrySelectorNavigator {
  const SearchDelegateNavigator._({
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showCountryCode,
    super.sortCountries,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
  });

  CountrySelectorSearchDelegate _getCountrySelectorSearchDelegate({
    required final ValueChanged<Country> onCountrySelected,
    final ScrollController? scrollController,
  }) =>
      CountrySelectorSearchDelegate(
        onCountrySelected: onCountrySelected,
        scrollController: scrollController,
        addFavoritesSeparator: addSeparator,
        countries: countries,
        favoriteCountries: favorites ?? <IsoCode>[],
        noResultMessage: noResultMessage,
        searchAutofocus: searchAutofocus,
        showCountryCode: showCountryCode,
        titleStyle: titleStyle,
        subtitleStyle: subtitleStyle,
      );

  @override
  Future<Country?> navigate(final BuildContext context) => showSearch(
        context: context,
        delegate: _getCountrySelectorSearchDelegate(
          onCountrySelected: (final Country country) =>
              Navigator.pop(context, country),
        ),
      );
}

class BottomSheetNavigator extends CountrySelectorNavigator {
  const BottomSheetNavigator._({
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showCountryCode,
    super.sortCountries,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
  });

  @override
  Future<Country?> navigate(final BuildContext context) {
    Country? selected;
    final PersistentBottomSheetController<Country?> ctrl =
        showBottomSheet<Country?>(
      context: context,
      builder: (final _) => MediaQuery(
        data: MediaQueryData.fromView(WidgetsBinding.instance.window),
        child: SafeArea(
          child: _getCountrySelector(
            onCountrySelected: (final Country country) {
              selected = country;
              Navigator.pop(context, country);
            },
          ),
        ),
      ),
    );
    return ctrl.closed.then((final _) => selected);
  }
}

class ModalBottomSheetNavigator extends CountrySelectorNavigator {
  const ModalBottomSheetNavigator._({
    this.height,
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showCountryCode,
    super.sortCountries,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
  });
  final double? height;

  @override
  Future<Country?> navigate(final BuildContext context) =>
      showModalBottomSheet<Country>(
        context: context,
        builder: (final _) => SizedBox(
          height: height ?? MediaQuery.of(context).size.height - 90,
          child: _getCountrySelector(
            onCountrySelected: (final Country country) =>
                Navigator.pop(context, country),
          ),
        ),
        isScrollControlled: true,
      );
}

class DraggableModalBottomSheetNavigator extends CountrySelectorNavigator {
  const DraggableModalBottomSheetNavigator._({
    this.initialChildSize = 0.7,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.85,
    this.borderRadius,
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showCountryCode,
    super.sortCountries,
    super.flagSize,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
  });
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final BorderRadiusGeometry? borderRadius;

  @override
  Future<Country?> navigate(final BuildContext context) {
    final BorderRadiusGeometry effectiveBorderRadius = borderRadius ??
        const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        );
    return showModalBottomSheet<Country>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
      ),
      builder: (final _) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (
          final BuildContext context,
          final ScrollController scrollController,
        ) =>
            DecoratedBox(
          decoration: ShapeDecoration(
            color: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: effectiveBorderRadius,
            ),
          ),
          child: _getCountrySelector(
            onCountrySelected: (final Country country) =>
                Navigator.pop(context, country),
            scrollController: scrollController,
          ),
        ),
      ),
      useRootNavigator: useRootNavigator,
      isScrollControlled: true,
    );
  }
}
