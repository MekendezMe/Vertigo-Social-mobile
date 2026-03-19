part of 'vertigo_theme.dart';

class ThemeTextStyles extends ThemeExtension<ThemeTextStyles> {
  static final String _defaultFontFamily = Platform.isAndroid
      ? 'Roboto'
      : '.SF UI Text';
  final TextStyle title1Bold;
  final TextStyle title2Heavy;
  final TextStyle title2Bold;
  final TextStyle title2Semibold;
  final TextStyle title3Bold;
  final TextStyle title3Light;
  final TextStyle buttonBold;
  final TextStyle htmlDescription;
  final TextStyle headlineBold;
  final TextStyle headlineMedium;
  final TextStyle headlineRegular;
  final TextStyle headlineVoting;
  final TextStyle textHeavy;
  final TextStyle textBold;
  final TextStyle textSemibold;
  final TextStyle textSemiboldList;
  final TextStyle textMedium;
  final TextStyle textRegular;
  final TextStyle textListRegular;
  ThemeTextStyles({
    required this.title1Bold,
    required this.title2Heavy,
    required this.title2Bold,
    required this.title2Semibold,
    required this.title3Bold,
    required this.title3Light,
    required this.buttonBold,
    required this.htmlDescription,
    required this.headlineBold,
    required this.headlineMedium,
    required this.headlineRegular,
    required this.headlineVoting,
    required this.textHeavy,
    required this.textBold,
    required this.textSemibold,
    required this.textSemiboldList,
    required this.textMedium,
    required this.textRegular,
    required this.textListRegular,
  });

  static ThemeTextStyles get light {
    return _getTextStylesForColors(ThemeColors.light);
  }

  static ThemeTextStyles get dark {
    return _getTextStylesForColors(ThemeColors.dark);
  }

  static ThemeTextStyles _getTextStylesForColors(ThemeColors colors) {
    return ThemeTextStyles(
      title1Bold: _styledText(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        letterSpacingIOS: -0.8,
        letterSpacingAndroid: 0.7,
        heightMultiplier: 1.14,
        color: colors.black19172F,
      ),
      title2Heavy: _styledText(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        letterSpacingIOS: -0.9,
        letterSpacingAndroid: 0.65,
        heightMultiplier: 0.95,
        color: colors.blackText,
      ),
      title2Bold: _styledText(
        fontSize: 21.0,
        fontWeight: FontWeight.bold,
        letterSpacingIOS: -0.95,
        letterSpacingAndroid: 0.2,
        heightMultiplier: 1.25,
        color: colors.blackText,
      ),
      title2Semibold: _styledText(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        letterSpacingIOS: -1.1,
        letterSpacingAndroid: -0.15,
        heightMultiplier: 1.25,
        color: colors.blackText,
      ),
      title3Bold: _styledText(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacingIOS: -0.9,
        letterSpacingAndroid: 0.1,
        heightMultiplier: 1.25,
        color: colors.blackText,
      ),
      title3Light: _styledText(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        letterSpacingIOS: -1.1,
        letterSpacingAndroid: -0.45,
        heightMultiplier: 0.75,
        color: colors.veryDarkBlueGreen,
      ),
      buttonBold: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        letterSpacingIOS: -0.25,
        letterSpacingAndroid: 0.6,
        heightMultiplier: 1.14,
        color: colors.blackText,
      ),
      htmlDescription: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        letterSpacingIOS: -0.7,
        letterSpacingAndroid: -0.2,
        heightMultiplier: 1.5,
        color: colors.blackText,
      ),
      headlineBold: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        letterSpacingIOS: -0.7,
        letterSpacingAndroid: 0.2,
        heightMultiplier: 1.14,
        color: colors.blackText,
      ),
      headlineMedium: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacingIOS: -0.8,
        letterSpacingAndroid: -0.25,
        heightMultiplier: 1.14,
        color: colors.blackText,
      ),
      headlineRegular: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        letterSpacingIOS: -0.7,
        letterSpacingAndroid: -0.2,
        heightMultiplier: 1.15,
        color: colors.veryDarkGray,
      ),
      headlineVoting: _styledText(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacingIOS: -0.75,
        letterSpacingAndroid: -0.35,
        heightMultiplier: 1.25,
        color: colors.blackText,
      ),
      textHeavy: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        letterSpacingIOS: -0.7,
        letterSpacingAndroid: 0.4,
        heightMultiplier: 1.5,
        color: colors.blackText,
      ),
      textBold: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacingIOS: -0.7,
        letterSpacingAndroid: 0.1,
        heightMultiplier: 1.5,
        color: colors.blackText,
      ),
      textSemibold: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacingIOS: -0.7,
        letterSpacingAndroid: -0.1,
        heightMultiplier: 1.5,
        color: colors.blackText,
      ),
      textSemiboldList: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacingIOS: -0.7,
        letterSpacingAndroid: -0.1,
        heightMultiplier: 1.2,
        color: colors.blackText,
      ),
      textMedium: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacingIOS: -0.75,
        letterSpacingAndroid: -0.25,
        heightMultiplier: 1.5,
        color: colors.veryDarkGray,
      ),
      textRegular: _styledText(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        letterSpacingIOS: -0.8,
        letterSpacingAndroid: -0.35,
        heightMultiplier: 1.5,
        color: colors.blackText,
      ),
      textListRegular: _styledText(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        letterSpacingIOS: -0.75,
        letterSpacingAndroid: -0.35,
        heightMultiplier: 1.20,
        color: colors.blackText,
      ),
    );
  }

  @override
  ThemeExtension<ThemeTextStyles> copyWith() {
    return ThemeTextStyles(
      title1Bold: title1Bold,
      title2Heavy: title2Heavy,
      title2Bold: title2Bold,
      title2Semibold: title2Semibold,
      title3Bold: title3Bold,
      title3Light: title3Light,
      buttonBold: buttonBold,
      htmlDescription: htmlDescription,
      headlineBold: headlineBold,
      headlineMedium: headlineMedium,
      headlineRegular: headlineRegular,
      headlineVoting: headlineVoting,
      textHeavy: textHeavy,
      textBold: textBold,
      textSemibold: textSemibold,
      textSemiboldList: textSemiboldList,
      textMedium: textMedium,
      textRegular: textRegular,
      textListRegular: textListRegular,
    );
  }

  @override
  ThemeExtension<ThemeTextStyles> lerp(
    ThemeExtension<ThemeTextStyles>? other,
    double t,
  ) {
    return other is! ThemeTextStyles ? this : other;
  }

  static TextStyle _styledText({
    String? fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required double letterSpacingIOS,
    required double letterSpacingAndroid,
    required double heightMultiplier,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? _defaultFontFamily,
      color: color,
      fontSize: fontSize,
      height: heightMultiplier,
      letterSpacing: Platform.isIOS ? letterSpacingIOS : letterSpacingAndroid,
      fontWeight: fontWeight,
      decorationColor: null,
      decorationStyle: TextDecorationStyle.solid,
      decoration: TextDecoration.none,
    );
  }
}

extension TextStyleExtension on TextStyle {
  static final String _defaultFontFamily = Platform.isAndroid
      ? 'Roboto'
      : '.SF UI Text';

  TextStyle modify({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacingIOS,
    double? letterSpacingAndroid,
    double? heightMultiplier,
    bool isUnderlined = false,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? _defaultFontFamily,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      height: heightMultiplier ?? height,
      letterSpacing: Platform.isIOS
          ? letterSpacingIOS ?? letterSpacing
          : letterSpacingAndroid ?? letterSpacing,
      fontWeight: fontWeight ?? this.fontWeight,
      decorationColor: isUnderlined ? color ?? this.color : null,
      decorationStyle: TextDecorationStyle.solid,
      decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
    );
  }
}
