import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MessageUtils {
  static void showErrorInFlushBar(BuildContext context, String? message, {int? duration}) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      icon: const Icon(
        Icons.error_outline,
        size: 28.0,
        color: Colors.red,
      ),
      duration: Duration(seconds: duration ?? 3),
      leftBarIndicatorColor: Colors.red,
    ).show(context);
  }

  static void showMessageInFlushBar(BuildContext context, String message) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      icon: const Icon(
        Icons.notifications,
        size: 28.0,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: Colors.deepPurple,
    ).show(context);
  }
}
