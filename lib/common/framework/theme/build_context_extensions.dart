part of 'vertigo_theme.dart';

extension BuildContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  ThemeColors get color => theme.extension<ThemeColors>()!;

  ThemeTextStyles get textStyle => theme.extension<ThemeTextStyles>()!;

  bool get isDarkMode => theme.brightness == Brightness.dark;
}
