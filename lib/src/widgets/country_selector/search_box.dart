import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    required this.onChanged,
    required this.onSubmitted,
    required this.autofocus,
    this.decoration,
    this.style,
    this.searchIconColor,
    super.key,
  }) : super();
  final Function(String) onChanged;
  final Function() onSubmitted;
  final bool autofocus;
  final InputDecoration? decoration;
  final TextStyle? style;
  final Color? searchIconColor;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: TextField(
          autofocus: autofocus,
          onChanged: onChanged,
          onSubmitted: (final _) => onSubmitted(),
          cursorColor: style?.color,
          style: style,
          decoration: decoration ??
              InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: searchIconColor ??
                      (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.black38),
                ),
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Function(String p1)>.has('onChanged', onChanged),
      )
      ..add(ColorProperty('searchIconColor', searchIconColor))
      ..add(DiagnosticsProperty<TextStyle?>('style', style))
      ..add(DiagnosticsProperty<InputDecoration?>('decoration', decoration))
      ..add(DiagnosticsProperty<bool>('autofocus', autofocus))
      ..add(ObjectFlagProperty<Function()>.has('onSubmitted', onSubmitted));
  }
}
