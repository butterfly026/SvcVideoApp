part of theme;

/// 可根据实际UI设计扩展颜色
extension ColorSchemaExtension on ColorScheme {
  static const Color _mask = Color(0x00000000);
  static const Color _darkMask = Color(0x4D000000);

  static const Color _gray = Color(0xFFD8D8D8);
  static const Color _darkGray = Color(0xFFD8D8D8);

  static const Color _divider = Color.fromRGBO(59, 58, 58, 1);
  static const Color _darkDivider = Color.fromRGBO(59, 58, 58, 1);

  Color get mask {
    if (brightness == Brightness.light) {
      return _mask;
    }
    return _darkMask;
  }

  Color get gray {
    if (brightness == Brightness.light) {
      return _gray;
    }
    return _darkGray;
  }

  Color get divider {
    if (brightness == Brightness.light) {
      return _divider;
    }
    return _darkDivider;
  }
}
