part of theme;

mixin AppTheme {
  static const margin = 16.0;

  static const primary = Color(0xFF2972FE);
  static const success = Color(0xFF23A757);
  static const warning = Colors.orange;
  static const error = Color(0xFFDA1414);
  static const info = Color(0xFF2E5AAC);

  static ThemeMode mode = ThemeMode.system;

  static SystemUiOverlayStyle get systemStyle => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static SystemUiOverlayStyle get systemStyleLight => systemStyle.copyWith(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static SystemUiOverlayStyle get systemStyleDark => systemStyle.copyWith(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: const Color(0xFF0D0D0D),
        systemNavigationBarIconBrightness: Brightness.light,
      );

  static void setSystemStyle() {
    switch (mode) {
      case ThemeMode.system:
        if (Screen.mediaQuery.platformBrightness == Brightness.dark) {
          SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
        } else {
          SystemChrome.setSystemUIOverlayStyle(systemStyleLight);
        }
        break;
      case ThemeMode.light:
        SystemChrome.setSystemUIOverlayStyle(systemStyleLight);
        break;
      case ThemeMode.dark:
        SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
        break;
    }
  }

  static ThemeData light() {
    var scheme = ColorScheme.light(
      background: Colors.white,
      onBackground: const Color(0xFF333333),
      surface: Colors.white,
      onSurface: const Color(0xFF333333),
      primary: primary,
      onPrimary: Colors.white,
      secondary: const Color(0xFFFFB800),
      onSecondary: Colors.white,
      tertiary: const Color(0xFFF4F6F9),
      outline: const Color(0xFFF4F6F9),
      shadow: const Color(0xFF5A6CEA).withOpacity(0.08),
      error: error,
      onError: Colors.white,
    );
    return _getTheme(scheme);
  }

  static ThemeData dark() {
    var scheme = ColorScheme.dark(
      background: const Color(0xFF0D0D0D),
      onBackground: Colors.white,
      surface: const Color(0xFF252525),
      onSurface: Colors.white,
      primary: primary,
      onPrimary: Colors.white,
      secondary: const Color(0xFFFFB800),
      onSecondary: Colors.white,
      tertiary: const Color(0xFF141414),
      outline: const Color(0xFF252525),
      shadow: const Color(0xFF777777).withOpacity(0.08),
      error: error,
      onError: Colors.white,
    );
    return _getTheme(scheme);
  }

  static ThemeData _getTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: false,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      // splashColor: Colors.transparent,
      // highlightColor: Colors.transparent,
      dialogTheme: DialogTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: Dimens.font_sp18,
          fontWeight: FontWeight.w600,
          color: scheme.brightness == Brightness.light
              ? scheme.onBackground
              : scheme.surface,
        ),
        contentTextStyle: TextStyle(
          fontSize: Dimens.font_sp20,
          fontFamily: 'Sans',
        ),
        backgroundColor: scheme.brightness == Brightness.light
            ? scheme.surface
            : scheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimens.gap_dp10,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        backgroundColor: scheme.brightness == Brightness.light
            ? scheme.surface
            : scheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.gap_dp30),
            topRight: Radius.circular(Dimens.gap_dp30),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.background,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: scheme.onBackground,
          size: Dimens.gap_dp22,
        ),
        titleTextStyle: TextStyle(
          color: scheme.onBackground,
          fontSize: Dimens.font_sp18,
          fontWeight: FontWeight.w600,
          height: 1.2,
          fontFamily: 'Sans',
        ),
        toolbarTextStyle: TextStyle(
          color: scheme.onBackground,
          fontSize: Dimens.font_sp22,
          fontWeight: FontWeight.w600,
          height: 1.2,
          fontFamily: 'Sans',
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontSize: Dimens.font_sp16,
          color: scheme.onBackground,
          fontFamily: 'Sans',
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Dimens.font_sp16,
          height: 1.2,
          color: scheme.onBackground,
          fontFamily: 'Sans',
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        elevation: 0,
        color: scheme.background,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: scheme.background,
        unselectedItemColor: scheme.onBackground.withOpacity(0.5),
        selectedItemColor: scheme.primary,
        unselectedLabelStyle: TextStyle(fontSize: Dimens.font_sp13, height: 1.6),
        selectedLabelStyle: TextStyle(fontSize: Dimens.font_sp13, height: 1.6),
        unselectedIconTheme: IconThemeData(
          size: Dimens.gap_dp24,
          color: scheme.onBackground.withOpacity(0.5),
        ),
        selectedIconTheme: IconThemeData(
          size: Dimens.gap_dp24,
          color: scheme.primary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          minimumSize: MaterialStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isCollapsed: true,
        isDense: true,
        fillColor: scheme.surface,
        labelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
          color: scheme.onBackground,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: TextStyle(
          fontSize: Dimens.font_sp14,
          color: scheme.onBackground.withOpacity(0.7),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimens.gap_dp20,
          vertical: Dimens.gap_dp14,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.background,
        labelStyle: TextStyle(
          color: scheme.primary,
          fontSize: Dimens.font_sp18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Sans',
        ),
        unselectedLabelStyle: TextStyle(
          color: scheme.onBackground,
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Sans',
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp6),
      ),
      dividerTheme: DividerThemeData(
        thickness: Dimens.gap_dp1,
        color: scheme.onBackground.withOpacity(0.08),
      ),
    );
  }
}
