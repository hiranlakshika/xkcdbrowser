import 'package:flutter/material.dart';

class NavigationUtils {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Push a named route onto the navigator.
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace the current route of the navigator by pushing the route named
  Future<dynamic> pushReplacementNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Push the route with the given name onto the navigator, and then remove all
  /// the previous routes until the `predicate` returns true.
  Future<dynamic> pushNamedAndRemoveUntil<T extends Object>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }
}
