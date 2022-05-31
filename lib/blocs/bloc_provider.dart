import 'package:flutter/material.dart';

import 'bloc_holder.dart';

class BlocProvider<T extends BlocBase?> extends InheritedWidget {
  final T bloc;

  const BlocProvider({
    Key? key,
    required Widget child,
    required T bloc,
  })  : bloc = bloc,
        super(key: key, child: child);

  static T of<T extends BlocBase>(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<BlocProvider>()!;
    return provider.bloc as T;
  }

  @override
  bool updateShouldNotify(BlocProvider oldWidget) => false;
}
