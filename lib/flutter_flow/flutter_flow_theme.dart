// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) {
    return LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  late Color grayscale10;
  late Color grayscale20;
  late Color grayscale30;
  late Color grayscale40;
  late Color grayscale50;
  late Color grayscale60;
  late Color grayscale70;
  late Color grayscale80;
  late Color grayscale90;
  late Color grayscale100;
  late Color webNav;
  late Color textNavBar;
  late Color hoverNavBar;
  late Color customColor1;
  late Color primaryApp;
  late Color secondaryApp;
  late Color header;
  late Color primaryDashboard;

  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  @Deprecated('Use headlineMediumFamily instead')
  String get title2Family => typography.headlineMediumFamily;
  @Deprecated('Use headlineMedium instead')
  TextStyle get title2 => typography.headlineMedium;
  @Deprecated('Use headlineSmallFamily instead')
  String get title3Family => typography.headlineSmallFamily;
  @Deprecated('Use headlineSmall instead')
  TextStyle get title3 => typography.headlineSmall;
  @Deprecated('Use titleMediumFamily instead')
  String get subtitle1Family => typography.titleMediumFamily;
  @Deprecated('Use titleMedium instead')
  TextStyle get subtitle1 => typography.titleMedium;
  @Deprecated('Use titleSmallFamily instead')
  String get subtitle2Family => typography.titleSmallFamily;
  @Deprecated('Use titleSmall instead')
  TextStyle get subtitle2 => typography.titleSmall;
  @Deprecated('Use bodyMediumFamily instead')
  String get bodyText1Family => typography.bodyMediumFamily;
  @Deprecated('Use bodyMedium instead')
  TextStyle get bodyText1 => typography.bodyMedium;
  @Deprecated('Use bodySmallFamily instead')
  String get bodyText2Family => typography.bodySmallFamily;
  @Deprecated('Use bodySmall instead')
  TextStyle get bodyText2 => typography.bodySmall;

  String get displayLargeFamily => typography.displayLargeFamily;
  bool get displayLargeIsCustom => typography.displayLargeIsCustom;
  TextStyle get displayLarge => typography.displayLarge;
  String get displayMediumFamily => typography.displayMediumFamily;
  bool get displayMediumIsCustom => typography.displayMediumIsCustom;
  TextStyle get displayMedium => typography.displayMedium;
  String get displaySmallFamily => typography.displaySmallFamily;
  bool get displaySmallIsCustom => typography.displaySmallIsCustom;
  TextStyle get displaySmall => typography.displaySmall;
  String get headlineLargeFamily => typography.headlineLargeFamily;
  bool get headlineLargeIsCustom => typography.headlineLargeIsCustom;
  TextStyle get headlineLarge => typography.headlineLarge;
  String get headlineMediumFamily => typography.headlineMediumFamily;
  bool get headlineMediumIsCustom => typography.headlineMediumIsCustom;
  TextStyle get headlineMedium => typography.headlineMedium;
  String get headlineSmallFamily => typography.headlineSmallFamily;
  bool get headlineSmallIsCustom => typography.headlineSmallIsCustom;
  TextStyle get headlineSmall => typography.headlineSmall;
  String get titleLargeFamily => typography.titleLargeFamily;
  bool get titleLargeIsCustom => typography.titleLargeIsCustom;
  TextStyle get titleLarge => typography.titleLarge;
  String get titleMediumFamily => typography.titleMediumFamily;
  bool get titleMediumIsCustom => typography.titleMediumIsCustom;
  TextStyle get titleMedium => typography.titleMedium;
  String get titleSmallFamily => typography.titleSmallFamily;
  bool get titleSmallIsCustom => typography.titleSmallIsCustom;
  TextStyle get titleSmall => typography.titleSmall;
  String get labelLargeFamily => typography.labelLargeFamily;
  bool get labelLargeIsCustom => typography.labelLargeIsCustom;
  TextStyle get labelLarge => typography.labelLarge;
  String get labelMediumFamily => typography.labelMediumFamily;
  bool get labelMediumIsCustom => typography.labelMediumIsCustom;
  TextStyle get labelMedium => typography.labelMedium;
  String get labelSmallFamily => typography.labelSmallFamily;
  bool get labelSmallIsCustom => typography.labelSmallIsCustom;
  TextStyle get labelSmall => typography.labelSmall;
  String get bodyLargeFamily => typography.bodyLargeFamily;
  bool get bodyLargeIsCustom => typography.bodyLargeIsCustom;
  TextStyle get bodyLarge => typography.bodyLarge;
  String get bodyMediumFamily => typography.bodyMediumFamily;
  bool get bodyMediumIsCustom => typography.bodyMediumIsCustom;
  TextStyle get bodyMedium => typography.bodyMedium;
  String get bodySmallFamily => typography.bodySmallFamily;
  bool get bodySmallIsCustom => typography.bodySmallIsCustom;
  TextStyle get bodySmall => typography.bodySmall;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF15203D); // Azul escuro padrão
  late Color secondary = const Color(0xFF15203D); // Azul escuro padrão
  late Color tertiary = const Color(0xFFD5D91B); // Amarelo padrão
  late Color alternate = const Color(0xFFFF5963);
  late Color primaryText = const Color(0xFF14181B);
  late Color secondaryText = const Color(0xFF57636C);
  late Color primaryBackground = const Color(0xFFFFFFFF);
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  late Color accent1 = const Color(0xFF000000);
  late Color accent2 = const Color(0xFFFFFFFF);
  late Color accent3 = const Color(0xFFFFF9EB);
  late Color accent4 = const Color(0xFFF9F9F9);
  late Color success = const Color(0xFF3D843C);
  late Color warning = const Color(0xFFFACC15);
  late Color error = const Color(0xFFE53935);
  late Color info = const Color(0xFF1C4494);

  late Color grayscale10 = const Color(0xFFFDFDFD);
  late Color grayscale20 = const Color(0xFFECF1F6);
  late Color grayscale30 = const Color(0xFFE3E9ED);
  late Color grayscale40 = const Color(0xFFD1D8DD);
  late Color grayscale50 = const Color(0xFFBFC6CC);
  late Color grayscale60 = const Color(0xFF9CA4AB);
  late Color grayscale70 = const Color(0xFF78828A);
  late Color grayscale80 = const Color(0xFF66707A);
  late Color grayscale90 = const Color(0xFF434E58);
  late Color grayscale100 = const Color(0xFF171725);
  late Color webNav = const Color(0xFFF9F9F9);
  late Color textNavBar = const Color(0xF9FFFFFF);
  late Color hoverNavBar = const Color(0xFFECECEC);
  late Color customColor1 = const Color(0xFFEBB18A);
  late Color primaryApp = const Color(0xFFF87146);
  late Color secondaryApp = const Color(0xFF332C45);
  late Color header = const Color(0xFFFFFFFF);
  late Color primaryDashboard = const Color(0xFFBC19EB);
}

abstract class Typography {
  String get displayLargeFamily;
  bool get displayLargeIsCustom;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  bool get displayMediumIsCustom;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  bool get displaySmallIsCustom;
  TextStyle get displaySmall;
  String get headlineLargeFamily;
  bool get headlineLargeIsCustom;
  TextStyle get headlineLarge;
  String get headlineMediumFamily;
  bool get headlineMediumIsCustom;
  TextStyle get headlineMedium;
  String get headlineSmallFamily;
  bool get headlineSmallIsCustom;
  TextStyle get headlineSmall;
  String get titleLargeFamily;
  bool get titleLargeIsCustom;
  TextStyle get titleLarge;
  String get titleMediumFamily;
  bool get titleMediumIsCustom;
  TextStyle get titleMedium;
  String get titleSmallFamily;
  bool get titleSmallIsCustom;
  TextStyle get titleSmall;
  String get labelLargeFamily;
  bool get labelLargeIsCustom;
  TextStyle get labelLarge;
  String get labelMediumFamily;
  bool get labelMediumIsCustom;
  TextStyle get labelMedium;
  String get labelSmallFamily;
  bool get labelSmallIsCustom;
  TextStyle get labelSmall;
  String get bodyLargeFamily;
  bool get bodyLargeIsCustom;
  TextStyle get bodyLarge;
  String get bodyMediumFamily;
  bool get bodyMediumIsCustom;
  TextStyle get bodyMedium;
  String get bodySmallFamily;
  bool get bodySmallIsCustom;
  TextStyle get bodySmall;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Nunito';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => GoogleFonts.nunito(
        color: theme.grayscale100,
        fontWeight: FontWeight.normal,
        fontSize: 57.0,
      );
  String get displayMediumFamily => 'Nunito';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => GoogleFonts.nunito(
        color: theme.grayscale100,
        fontWeight: FontWeight.w800,
        fontSize: 48.0,
      );
  String get displaySmallFamily => 'Nunito';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => GoogleFonts.nunito(
        color: theme.grayscale100,
        fontWeight: FontWeight.w500,
        fontSize: 24.0,
        fontStyle: FontStyle.normal,
      );
  String get headlineLargeFamily => 'Nunito';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => GoogleFonts.nunito(
        color: theme.grayscale100,
        fontWeight: FontWeight.bold,
        fontSize: 40.0,
      );
  String get headlineMediumFamily => 'Nunito';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => GoogleFonts.nunito(
        color: theme.grayscale100,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        fontStyle: FontStyle.normal,
      );
  String get headlineSmallFamily => 'Nunito';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => GoogleFonts.nunito(
        color: theme.grayscale100,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      );
  String get titleLargeFamily => 'Nunito';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.nunito(
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      );
  String get titleMediumFamily => 'Nunito';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.nunito(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 18.0,
      );
  String get titleSmallFamily => 'Nunito';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.nunito(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get labelLargeFamily => 'Nunito';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.nunito(
        color: theme.accent2,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get labelMediumFamily => 'Nunito';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.nunito(
        color: theme.accent2,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelSmallFamily => 'Nunito';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.nunito(
        color: theme.accent2,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );
  String get bodyLargeFamily => 'Nunito';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.nunito(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Nunito';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.nunito(
        color: theme.grayscale100,
        fontWeight: FontWeight.w800,
        fontSize: 16.0,
      );
  String get bodySmallFamily => 'Nunito';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.nunito(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    TextStyle? font,
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = false,
    TextDecoration? decoration,
    double? lineHeight,
    List<Shadow>? shadows,
    String? package,
  }) {
    if (useGoogleFonts && fontFamily != null) {
      font = GoogleFonts.getFont(fontFamily,
          fontWeight: fontWeight ?? this.fontWeight,
          fontStyle: fontStyle ?? this.fontStyle);
    }

    return font != null
        ? font.copyWith(
            color: color ?? this.color,
            fontSize: fontSize ?? this.fontSize,
            letterSpacing: letterSpacing ?? this.letterSpacing,
            fontWeight: fontWeight ?? this.fontWeight,
            fontStyle: fontStyle ?? this.fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          )
        : copyWith(
            fontFamily: fontFamily,
            package: package,
            color: color,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          );
  }
}
