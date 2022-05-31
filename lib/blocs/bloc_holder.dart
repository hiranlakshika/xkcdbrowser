import 'package:flutter/material.dart';

import 'bloc_provider.dart';

abstract class BlocBase {
  void dispose();
}

class BlocHolder<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T Function() createBloc;

  const BlocHolder({Key? key, required this.child, required this.createBloc}) : super(key: key);

  @override
  State<BlocHolder> createState() => _BlocHolderState();
}

class _BlocHolderState<T extends BlocBase> extends State<BlocHolder> {
  T? _bloc;

  Function? hello;

  @override
  void initState() {
    super.initState();
    _bloc = widget.createBloc() as T?;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
  }
}
