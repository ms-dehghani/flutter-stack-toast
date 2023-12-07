import 'package:flutter/widgets.dart';

import './stack_toast_view.dart';

class StackToastManager {
  static StackToastManager? _singleton;

  factory StackToastManager(BuildContext context) {
    _singleton ??= StackToastManager._internal(context);
    return _singleton!;
  }

  OverlayState? _overlay;
  StackToastView? _toastView;
  GlobalKey<StackToastViewState> widgetKey = GlobalKey<StackToastViewState>();

  OverlayEntry? _overlayEntry;

  StackToastManager._internal(BuildContext context) {
    _overlay ??= Overlay.of(context);
  }

  void init() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return _toastView!;
      });
      _overlay?.insert(_overlayEntry!);
    }
  }

  void addItem({Widget? widget, Text? text}) {
    if (widgetKey.currentState == null) {
      _toastView ??= StackToastView(
        () {
          _overlayEntry?.remove();
          _overlayEntry = null;
          _toastView = null;
        },
        firstCallAfterBuild: () {
          widgetKey.currentState?.addWidget(view: widget, text: text);
        },
        key: widgetKey,
      );
      init();
    } else {
      widgetKey.currentState?.addWidget(view: widget, text: text);
    }
  }

  void removeLast() {
    widgetKey.currentState?.removeLast();
  }

  void clear() {
    widgetKey.currentState?.clear();
  }
}
