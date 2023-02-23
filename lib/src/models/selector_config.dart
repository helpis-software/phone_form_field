import 'package:flutter/foundation.dart';

@Deprecated('use CountrySelectorNavigation instead')
abstract class SelectorConfig {
  @Deprecated('use CountrySelectorNavigation instead')
  const SelectorConfig();

  @Deprecated('use CountrySelectorNavigation instead')
  const factory SelectorConfig.coverSheet() = SelectorConfigCoverSheet;

  @Deprecated('use CountrySelectorNavigation instead')
  const factory SelectorConfig.bottomSheet(final double? height) =
      SelectorConfigBottomSheet;

  @Deprecated('use CountrySelectorNavigation instead')
  const factory SelectorConfig.dialog() = SelectorConfigDialog;
}

@Deprecated('use CountrySelectorNavigation instead')
class SelectorConfigDialog extends SelectorConfig {
  @Deprecated('use CountrySelectorNavigation instead')
  const SelectorConfigDialog();
}

@Deprecated('use CountrySelectorNavigation instead')
class SelectorConfigCoverSheet extends SelectorConfig {
  @Deprecated('use CountrySelectorNavigation instead')
  const SelectorConfigCoverSheet();
}

@Deprecated('use CountrySelectorNavigation instead')
@immutable
class SelectorConfigBottomSheet extends SelectorConfig {
  @Deprecated('use CountrySelectorNavigation instead')
  const SelectorConfigBottomSheet(this.height);
  final double? height;

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SelectorConfigBottomSheet && other.height == height;
  }

  @override
  int get hashCode => height.hashCode;
}
