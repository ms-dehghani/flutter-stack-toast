import 'package:flutter/material.dart';

import 'lib/stack_toast_manager.dart';

class StackToast {
  static void showToast(BuildContext context, String text) {
    StackToastManager(context).addItem(
      text: Text(
        text,
        style: const TextStyle(
            color: Colors.black, fontSize: 15, decoration: TextDecoration.none),
      ),
    );
  }

  static void showTextToast(BuildContext context, Text text) {
    StackToastManager(context).addItem(text: text);
  }

  static void clear(BuildContext context) {
    StackToastManager(context).clear();
  }

  static void showCustomToast(BuildContext context, Widget widget) {
    StackToastManager(context).addItem(widget: widget);
  }
}
