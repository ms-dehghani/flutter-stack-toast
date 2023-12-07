import 'package:flutter/widgets.dart';

import 'lib/stack_toast_manager.dart';

class StackToast {
  static void showToast(BuildContext context, Text text) {
    StackToastManager(context).addItem(text: text);
  }

  static void clear(BuildContext context) {
    StackToastManager(context).clear();
  }

  static void showCustomToast(BuildContext context, Widget widget) {
    StackToastManager(context).addItem(widget: widget);
  }
}
