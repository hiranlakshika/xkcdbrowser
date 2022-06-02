import 'package:flutter/material.dart';

import '../util/theme.dart';

class XkcdCustomWidgets {
  static Widget xkcdCustomCard({required Widget child}) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: XkcdColors.celadon,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: child,
        ),
      ),
    );
  }
}