import 'package:flutter/widgets.dart';

import 'widget/toast_view.dart';

class ToastManager {
  static ToastManager? _singleton;

  factory ToastManager(BuildContext context) {
    _singleton ??= ToastManager._internal(context);
    return _singleton!;
  }

  OverlayState? _overlay;
  ToastView? _toastView;
  GlobalKey<ToastViewState> widgetKey = GlobalKey<ToastViewState>();

  OverlayEntry? _overlayEntry;

  ToastManager._internal(BuildContext context) {
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
      _toastView ??= ToastView(
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
