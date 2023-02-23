class Patterns {
  /// accepted punctuation within a phone number
  static const String punctuation = r' ()\[\]\-\.\/\\';
  static const String plus = '\\+\uff0b';

  /// Westhen and easthern arabic numerals
  static const String digits = '0-9\uff10-\uff19٩\u0660--۹';
}
