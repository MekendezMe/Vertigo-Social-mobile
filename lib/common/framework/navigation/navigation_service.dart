import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static BuildContext get context => navigatorKey.currentContext!;
}
