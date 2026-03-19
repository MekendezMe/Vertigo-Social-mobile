import 'dart:io';

import 'package:flutter/material.dart';

part 'build_context_extensions.dart';
part 'theme_colors.dart';
part 'theme_text_styles.dart';

class VertigoTheme {
  static ThemeData get light {
    final themeColors = ThemeColors.light;
    final textStyle = ThemeTextStyles.light;

    final colorScheme = ColorScheme.fromSwatch().copyWith(
      secondary: themeColors.primary,
      brightness: Brightness.light,
    );

    final textTheme = TextTheme(
      displayLarge: textStyle.title1Bold,
      displayMedium: textStyle.title1Bold,
      displaySmall: textStyle.title2Bold,
      headlineMedium: textStyle.title3Bold,
      headlineSmall: textStyle.title1Bold,
      titleLarge: textStyle.title1Bold,
      labelLarge: textStyle.buttonBold,
      titleMedium: textStyle.textListRegular,
      titleSmall: textStyle.textRegular,
      bodyLarge: textStyle.textSemibold,
      bodyMedium: textStyle.textMedium,
      bodySmall: textStyle.textRegular,
      labelSmall: textStyle.title1Bold,
    );

    Iterable<ThemeExtension<dynamic>>? extensions = [
      themeColors,
      ThemeTextStyles.light,
    ];

    return ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: themeColors.primary,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: themeColors.scaffoldBackground,
      highlightColor: themeColors.veryLightGray.withValues(alpha: 0.6),
      splashColor: themeColors.veryLightGray,
      textTheme: textTheme,
      extensions: extensions,
    );
  }

  static ThemeData get dark {
    final themeColors = ThemeColors.dark;
    final textStyle = ThemeTextStyles.dark;

    final colorScheme = ColorScheme.fromSwatch().copyWith(
      secondary: themeColors.primary,
      brightness: Brightness.dark,
    );

    final textTheme = TextTheme(
      displayLarge: textStyle.title1Bold,
      displayMedium: textStyle.title1Bold,
      displaySmall: textStyle.title2Bold,
      headlineMedium: textStyle.title3Bold,
      headlineSmall: textStyle.title1Bold,
      titleLarge: textStyle.title1Bold,
      labelLarge: textStyle.buttonBold,
      titleMedium: textStyle.textListRegular,
      titleSmall: textStyle.textRegular,
      bodyLarge: textStyle.textSemibold,
      bodyMedium: textStyle.textMedium,
      bodySmall: textStyle.textRegular,
      labelSmall: textStyle.title1Bold,
    );

    Iterable<ThemeExtension<dynamic>>? extensions = [
      themeColors,
      ThemeTextStyles.dark,
    ];

    return ThemeData(
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: themeColors.primary,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: themeColors.scaffoldBackground,
      highlightColor: themeColors.veryLightGray.withValues(alpha: 0.6),
      splashColor: themeColors.veryLightGray,
      textTheme: textTheme,
      extensions: extensions,
    );
  }
}
