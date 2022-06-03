import 'package:flutter/material.dart';

class NamedChangeNotifier<T> extends ChangeNotifier {
  final _listeners = <String>[];

  T? _data;

  T? get data => _data;

  set data(T? data) {
    if (data == null || data.toString().isEmpty) {
      return;
    }

    _data = data;
    notifyListeners();
  }

  void addListenerWithName(VoidCallback? listener, String listenerName) {
    if (listener == null || _listeners.contains(listenerName)) {
      return;
    }

    _listeners.add(listenerName);
    super.addListener(listener);
  }

  void removeListenerWithName(VoidCallback? listener, String listenerName) {
    if (listener == null || !_listeners.contains(listenerName)) {
      return;
    }

    _listeners.remove(listenerName);
    super.removeListener(listener);
  }
}