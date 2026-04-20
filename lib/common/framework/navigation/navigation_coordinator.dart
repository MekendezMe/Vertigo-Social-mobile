import 'package:flutter/material.dart';

class NavigationCoordinator {
  const NavigationCoordinator();

  Future<T?> push<T extends Object?>({
    required BuildContext context,
    required Widget page,
    bool rootNavigator = false,
  }) {
    return Navigator.of(
      context,
    ).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  void pop<T extends Object?>({
    required BuildContext context,
    bool rootNavigator = false,
  }) {
    return Navigator.of(context).pop<T>();
  }

  void popUntil(
    bool Function(Route<dynamic>) predicate, {
    required BuildContext context,
  }) {
    Navigator.of(context).popUntil(predicate);
  }

  void popToRoot({required BuildContext context, bool rootNavigator = false}) {
    return popUntil((route) => route.isFirst, context: context);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>({
    required BuildContext context,
    required Widget page,
  }) {
    return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
    //   return Navigator.of(
    //     context,
    //     // rootNavigator: true,
    //   ).pushReplacement<T, TO>(MaterialPageRoute(builder: (_) => page));
    // }
  }
}
