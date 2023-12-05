import 'package:flutter/widgets.dart';
import 'package:flutter_stack_toast/src/toast_manager.dart';

class StackToast {
  static void showToast(BuildContext context, Text text) {
    ToastManager(context).addItem(text: text);
  }

  static void clear(BuildContext context) {
    ToastManager(context).clear();
  }

  static void showCustomToast(BuildContext context, Widget widget) {
    ToastManager(context).addItem(widget: widget);
  }
}
