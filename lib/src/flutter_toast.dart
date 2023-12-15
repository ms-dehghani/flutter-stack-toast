import 'package:flutter/material.dart';

import 'lib/stack_toast_manager.dart';

class FlutterToast {
  static void showToast(BuildContext context, String text, Duration duration) {
    FlutterToastManager(context).addItemToSimpleToast(
      duration,
      text: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 15, decoration: TextDecoration.none),
      ),
    );
  }

  static void showTextToast(BuildContext context, Text text, Duration duration) {
    FlutterToastManager(context).addItemToSimpleToast(duration, text: text);
  }

  static void clear(BuildContext context) {
    FlutterToastManager(context).clearFromSimple();
  }

  static void showCustomToast(BuildContext context, Widget widget, Duration duration) {
    FlutterToastManager(context).addItemToSimpleToast(duration, widget: widget);
  }

  static void showStackToast(BuildContext context, String text) {
    FlutterToastManager(context).addItemToStackToast(
      text: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 15, decoration: TextDecoration.none),
      ),
    );
  }

  static void showStackTextToast(BuildContext context, Text text) {
    FlutterToastManager(context).addItemToStackToast(text: text);
  }

  static void clearStackToast(BuildContext context) {
    FlutterToastManager(context).clearFromStack();
  }

  static void showStackCustomToast(BuildContext context, Widget widget) {
    FlutterToastManager(context).addItemToStackToast(widget: widget);
  }
}
