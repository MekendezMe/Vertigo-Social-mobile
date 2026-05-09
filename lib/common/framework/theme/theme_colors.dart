part of 'vertigo_theme.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color blackText;
  final Color veryDarkGray;
  final Color darkGray;
  final Color slateGrey;
  final Color gray;
  final Color lightGray;
  final Color veryLightGray;
  final Color black19172F;
  final Color black29262D;
  final Color votingBlue;
  final Color veryDarkBlueGreen;
  final Color accentGreen;
  final Color mainGreen;
  final Color lightGreen;
  final Color greenStatus;
  final Color veryLightGreen;
  final Color mintGreen;
  final Color accentBlue;
  final Color lightBlue;
  final Color skyBlue;
  final Color lightSky;
  final Color dodgerBlue;
  final Color red;
  final Color veryLightRed;
  final Color redED5B5B;
  final Color lightRed;
  final Color yellow;
  final Color lightYellow;
  final Color white;
  final Color lightBlueGradient;
  final Color brightLightGray;
  final Color purple;
  final Color lightPurple;
  final Color dimPurple;
  final Color votingBackGreen;
  final Color brown;
  final Color cameraDark;
  final Color butterscotch;

  final Color appBarShadow1;
  final Color appBarShadow2;
  final Color cardShadow1;
  final Color cardShadow2;
  final Color inputBorderRegular;
  final Color inputBorderFocused;
  final Color bottomTabBarShadow1;
  final Color bottomTabBarShadow2;

  Color get primary => purple;
  Color get primaryExtraLight => veryLightGreen;
  Color get additional => accentGreen;
  Color get strokeButtonHighlight => veryLightGreen;
  Color get inputBackground => veryLightGray.withValues(alpha: 0.5);
  Color get inputHint => darkGray;
  Color get inputValue => blackText;
  Color get inputSplash => veryLightGray;
  Color get inputHighlight => Colors.transparent;
  // Используется для выбранных неактивных переключателей
  Color get selectionDisableActive => veryLightGreen;
  Color get bottomTabBarTabDefaultIcon => gray;
  Color get bottomTabBarTabDefaultText => veryDarkGray;
  Color get bottomTabBarTabSelected => accentGreen;
  Color get overlayBackground => darkGray.withValues(alpha: 0.44);
  Color get scaffoldBackground => white;
  Color get popupBackground => white;
  Color get skeleton1 => veryLightGray;
  Color get skeleton2 => white;

  static ThemeColors get light {
    return ThemeColors(
      blackText: const Color(0xFF333333),
      slateGrey: const Color(0xFF656679),
      veryDarkGray: const Color(0xFF63637A),
      darkGray: const Color(0xFF868CA4),
      gray: const Color(0xFF9FA4B6),
      lightGray: const Color(0xFFBCC2D8),
      veryLightGray: const Color(0xFFEEEEF3),
      black19172F: const Color(0xFF19172F),
      black29262D: const Color(0xFF29262D),
      votingBlue: const Color(0xFF487CE1),
      veryDarkBlueGreen: const Color(0xFF0E3F54),
      accentGreen: const Color(0xFF01716D),
      mainGreen: const Color(0xFF00AA9F),
      lightGreen: const Color(0xFF59CFBD),
      greenStatus: const Color(0xFFA8D03C),
      veryLightGreen: const Color(0xFFDAEFF0),
      mintGreen: const Color(0xFF88DBE1),
      accentBlue: const Color(0xFF0C76C2),
      lightBlue: const Color(0xFFDAECFF),
      skyBlue: const Color(0xFF0EA4E6),
      lightSky: const Color(0xFFBDEBFF),
      dodgerBlue: const Color(0xFF3F8CFF),
      red: const Color(0xFFFF2F61),
      veryLightRed: const Color(0xFFFCDEEB),
      redED5B5B: const Color(0xFFED5B5B),
      lightRed: const Color(0xFFFFC1DB),
      yellow: const Color(0xFFFFBA34),
      butterscotch: const Color(0xFFFFC64B),
      lightYellow: const Color(0xFFFFEBC5),
      white: const Color(0xFFFFFFFF),
      lightBlueGradient: const Color(0xFFBBEAEF),
      brightLightGray: const Color(0xFFF7F7F9),
      purple: const Color.fromARGB(255, 94, 46, 161),
      lightPurple: const Color.fromARGB(255, 142, 86, 219),
      dimPurple: const Color.fromARGB(255, 76, 10, 168),
      votingBackGreen: const Color(0xFF008B89),
      brown: const Color(0xFF621700),
      appBarShadow1: const Color(0xFF1E2C5E).withAlpha((255 * 0.05).round()),
      appBarShadow2: const Color(0xFF435F8A).withAlpha((255 * 0.20).round()),
      cardShadow1: const Color(0xFF1E2C5E).withAlpha((255 * 0.05).round()),
      cardShadow2: const Color(0xFF435F8A).withAlpha((255 * 0.20).round()),
      cameraDark: const Color(0xFF11142D),
      inputBorderRegular: const Color(0xFFEAECF3),
      inputBorderFocused: const Color(0xFFDADDE9),
      bottomTabBarShadow1: const Color.fromARGB(
        255,
        59,
        92,
        211,
      ).withAlpha((0.12 * 255).round()),
      bottomTabBarShadow2: const Color(
        0xFF1E2C5E,
      ).withAlpha((0.14 * 255).round()),
    );
  }

  static ThemeColors get dark {
    return ThemeColors(
      blackText: const Color(0xFFEEEEF3),
      slateGrey: const Color(0xFFF6F6F7),
      veryDarkGray: const Color(0xFFBCC2D8),
      darkGray: const Color(0xFF868CA4),
      gray: const Color(0xFF63637A),
      lightGray: const Color(0xFF63637A),
      veryLightGray: const Color(0xFF333333),
      black19172F: const Color(0xFFFFFFFF),
      black29262D: const Color(0xFFFFFFFF),
      votingBlue: const Color(0xFF487CE1),
      veryDarkBlueGreen: const Color(0xFF0EA4E6),
      accentGreen: const Color(0xFF59CFBD),
      mainGreen: const Color(0xFF01716D),
      lightGreen: const Color(0xFF01716D),
      greenStatus: const Color(0xFFA8D03C),
      veryLightGreen: const Color(0xFF003739),
      mintGreen: const Color(0xFF003739),
      accentBlue: const Color(0xFF0EA4E6),
      lightBlue: const Color(0xFF002952),
      dodgerBlue: const Color(0xFF3F8CFF),
      cameraDark: const Color(0xFF11142D),
      skyBlue: const Color(0xFF0EA4E6),
      lightSky: const Color(0xFF002952),
      red: const Color(0xFFFF2F61),
      veryLightRed: const Color(0xFFFCDEEB),
      redED5B5B: const Color(0xFFED5B5B),
      lightRed: const Color(0xFF510022),
      yellow: const Color(0xFFFFBA34),
      butterscotch: const Color(0xFFFFC64B),
      lightYellow: const Color(0xFF472F00),
      white: Color(0xFF121212),
      lightBlueGradient: const Color(0xFF0D262C),
      brightLightGray: const Color(0xFF222222),
      purple: const Color.fromARGB(255, 94, 46, 161),
      lightPurple: const Color.fromARGB(255, 142, 86, 219),
      dimPurple: const Color.fromARGB(255, 76, 10, 168),
      votingBackGreen: const Color(0xFF008B89),
      brown: const Color(0xFF621700),
      appBarShadow1: const Color(0xFF1E2C5E).withAlpha((255 * 0.05).round()),
      appBarShadow2: const Color(0xFF435F8A).withAlpha((255 * 0.20).round()),
      cardShadow1: const Color(0xFF000000).withAlpha((255 * 0.05).round()),
      cardShadow2: const Color(0xFF000000).withAlpha((255 * 0.20).round()),
      inputBorderRegular: const Color(0xFF868CA4).withValues(alpha: 0.5),
      inputBorderFocused: const Color(0xFF868CA4),
      bottomTabBarShadow1: const Color(
        0xFF1E2C5E,
      ).withAlpha((0.12 * 255).round()),
      bottomTabBarShadow2: const Color(
        0xFF1E2C5E,
      ).withAlpha((0.14 * 255).round()),
    );
  }

  ThemeColors({
    required this.blackText,
    required this.veryDarkGray,
    required this.darkGray,
    required this.slateGrey,
    required this.gray,
    required this.lightGray,
    required this.veryLightGray,
    required this.black19172F,
    required this.black29262D,
    required this.votingBlue,
    required this.veryDarkBlueGreen,
    required this.accentGreen,
    required this.mainGreen,
    required this.lightGreen,
    required this.greenStatus,
    required this.veryLightGreen,
    required this.mintGreen,
    required this.accentBlue,
    required this.lightBlue,
    required this.skyBlue,
    required this.lightSky,
    required this.dodgerBlue,
    required this.cameraDark,
    required this.butterscotch,
    required this.red,
    required this.veryLightRed,
    required this.redED5B5B,
    required this.lightRed,
    required this.yellow,
    required this.lightYellow,
    required this.white,
    required this.lightBlueGradient,
    required this.brightLightGray,
    required this.purple,
    required this.votingBackGreen,
    required this.brown,
    required this.appBarShadow1,
    required this.appBarShadow2,
    required this.cardShadow1,
    required this.cardShadow2,
    required this.inputBorderRegular,
    required this.inputBorderFocused,
    required this.bottomTabBarShadow1,
    required this.bottomTabBarShadow2,
    required this.lightPurple,
    required this.dimPurple,
  });

  @override
  ThemeExtension<ThemeColors> copyWith() {
    return ThemeColors(
      blackText: blackText,
      veryDarkGray: veryDarkGray,
      darkGray: darkGray,
      slateGrey: slateGrey,
      gray: gray,
      lightGray: lightGray,
      veryLightGray: veryLightGray,
      black19172F: black19172F,
      black29262D: black29262D,
      votingBlue: votingBlue,
      veryDarkBlueGreen: veryDarkBlueGreen,
      accentGreen: accentGreen,
      mainGreen: mainGreen,
      lightGreen: lightGreen,
      greenStatus: greenStatus,
      veryLightGreen: veryLightGreen,
      mintGreen: mintGreen,
      accentBlue: accentBlue,
      lightBlue: lightBlue,
      skyBlue: skyBlue,
      dodgerBlue: dodgerBlue,
      lightSky: lightSky,
      cameraDark: cameraDark,
      butterscotch: butterscotch,
      red: red,
      veryLightRed: veryLightRed,
      redED5B5B: redED5B5B,
      lightRed: lightRed,
      yellow: yellow,
      lightYellow: lightYellow,
      white: white,
      lightBlueGradient: lightBlueGradient,
      brightLightGray: brightLightGray,
      purple: purple,
      votingBackGreen: votingBackGreen,
      brown: brown,
      appBarShadow1: appBarShadow1,
      appBarShadow2: appBarShadow2,
      cardShadow1: cardShadow1,
      cardShadow2: cardShadow2,
      inputBorderRegular: inputBorderRegular,
      inputBorderFocused: inputBorderFocused,
      bottomTabBarShadow1: bottomTabBarShadow1,
      bottomTabBarShadow2: bottomTabBarShadow2,
      lightPurple: lightPurple,
      dimPurple: dimPurple,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) {
      return this;
    }

    return ThemeColors(
      blackText: Color.lerp(blackText, other.blackText, t)!,
      veryDarkGray: Color.lerp(veryDarkGray, other.veryDarkGray, t)!,
      darkGray: Color.lerp(darkGray, other.darkGray, t)!,
      slateGrey: Color.lerp(slateGrey, other.slateGrey, t)!,
      gray: Color.lerp(gray, other.gray, t)!,
      lightGray: Color.lerp(lightGray, other.lightGray, t)!,
      veryLightGray: Color.lerp(veryLightGray, other.veryLightGray, t)!,
      black19172F: Color.lerp(black19172F, other.black19172F, t)!,
      black29262D: Color.lerp(black29262D, other.black29262D, t)!,
      votingBlue: Color.lerp(votingBlue, other.votingBlue, t)!,
      veryDarkBlueGreen: Color.lerp(
        veryDarkBlueGreen,
        other.veryDarkBlueGreen,
        t,
      )!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      mainGreen: Color.lerp(mainGreen, other.mainGreen, t)!,
      lightGreen: Color.lerp(lightGreen, other.lightGreen, t)!,
      greenStatus: Color.lerp(greenStatus, other.greenStatus, t)!,
      cameraDark: Color.lerp(cameraDark, other.cameraDark, t)!,
      dodgerBlue: Color.lerp(dodgerBlue, other.dodgerBlue, t)!,
      veryLightGreen: Color.lerp(veryLightGreen, other.veryLightGreen, t)!,
      mintGreen: Color.lerp(mintGreen, other.mintGreen, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      lightBlue: Color.lerp(lightBlue, other.lightBlue, t)!,
      skyBlue: Color.lerp(skyBlue, other.skyBlue, t)!,
      lightSky: Color.lerp(lightSky, other.lightSky, t)!,
      red: Color.lerp(red, other.red, t)!,
      veryLightRed: Color.lerp(veryLightRed, other.veryLightRed, t)!,
      redED5B5B: Color.lerp(redED5B5B, other.redED5B5B, t)!,
      lightRed: Color.lerp(lightRed, other.lightRed, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      butterscotch: Color.lerp(butterscotch, other.butterscotch, t)!,
      lightYellow: Color.lerp(lightYellow, other.lightYellow, t)!,
      white: Color.lerp(white, other.white, t)!,
      lightBlueGradient: Color.lerp(
        lightBlueGradient,
        other.lightBlueGradient,
        t,
      )!,
      brightLightGray: Color.lerp(brightLightGray, other.brightLightGray, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      votingBackGreen: Color.lerp(votingBackGreen, other.votingBackGreen, t)!,
      brown: Color.lerp(brown, other.brown, t)!,
      appBarShadow1: Color.lerp(appBarShadow1, other.appBarShadow1, t)!,
      appBarShadow2: Color.lerp(appBarShadow2, other.appBarShadow2, t)!,
      cardShadow1: Color.lerp(cardShadow1, other.cardShadow1, t)!,
      cardShadow2: Color.lerp(cardShadow2, other.cardShadow2, t)!,
      inputBorderRegular: Color.lerp(
        inputBorderRegular,
        other.inputBorderRegular,
        t,
      )!,
      inputBorderFocused: Color.lerp(
        inputBorderFocused,
        other.inputBorderFocused,
        t,
      )!,
      bottomTabBarShadow1: Color.lerp(
        bottomTabBarShadow1,
        other.bottomTabBarShadow1,
        t,
      )!,
      bottomTabBarShadow2: Color.lerp(
        bottomTabBarShadow2,
        other.bottomTabBarShadow2,
        t,
      )!,
      lightPurple: Color.lerp(lightPurple, other.purple, t)!,
      dimPurple: Color.lerp(dimPurple, other.purple, t)!,
    );
  }
}
