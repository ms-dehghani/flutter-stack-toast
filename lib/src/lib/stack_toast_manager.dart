import 'package:flutter/widgets.dart';

import './simple_toast_view.dart';
import './stack_toast_view.dart';

class FlutterToastManager {
  static FlutterToastManager? _singleton;

  factory FlutterToastManager(BuildContext context) {
    _singleton ??= FlutterToastManager._internal(context);
    return _singleton!;
  }

  OverlayState? _overlay;

  OverlayEntry? _simpleOverlayEntry;
  SimpleToastView? _simpleToastView;
  final GlobalKey<SimpleToastViewState> _simpleToastKey = GlobalKey<SimpleToastViewState>();

  StackToastView? _stackToastView;
  OverlayEntry? _stackOverlayEntry;
  final GlobalKey<StackToastViewState> _stackToastKey = GlobalKey<StackToastViewState>();

  FlutterToastManager._internal(BuildContext context) {
    _overlay ??= Overlay.of(context);
  }

  void initSimpleView() {
    if (_simpleOverlayEntry == null) {
      _simpleOverlayEntry = OverlayEntry(builder: (BuildContext context) {
        return _simpleToastView!;
      });
      _overlay?.insert(_simpleOverlayEntry!, above: _stackOverlayEntry);
    }
  }

  void addItemToSimpleToast(Duration duration, {Widget? widget, Text? text}) {
    if (_simpleToastKey.currentState == null) {
      _simpleToastView ??= SimpleToastView(
        () {
          _simpleOverlayEntry?.remove();
          _simpleOverlayEntry = null;
          _simpleToastView = null;
        },
        firstCallAfterBuild: () {
          _simpleToastKey.currentState?.addWidget(duration, view: widget, text: text);
        },
        key: _simpleToastKey,
      );
      initSimpleView();
    } else {
      _simpleToastKey.currentState?.addWidget(duration, view: widget, text: text);
    }
  }

  void removeFirstFromSimple() {
    _simpleToastKey.currentState?.removeFirst();
  }

  void clearFromSimple() {
    _simpleToastKey.currentState?.clear();
  }

  void initStackView() {
    if (_stackOverlayEntry == null) {
      _stackOverlayEntry = OverlayEntry(builder: (BuildContext context) {
        return _stackToastView!;
      });
      _overlay?.insert(_stackOverlayEntry!, below: _simpleOverlayEntry);
    }
  }

  void addItemToStackToast({Widget? widget, Text? text}) {
    if (_stackToastKey.currentState == null) {
      _stackToastView ??= StackToastView(
        () {
          _stackOverlayEntry?.remove();
          _stackOverlayEntry = null;
          _stackToastView = null;
        },
        firstCallAfterBuild: () {
          _stackToastKey.currentState?.addWidget(view: widget, text: text);
        },
        key: _stackToastKey,
      );
      initStackView();
    } else {
      _stackToastKey.currentState?.addWidget(view: widget, text: text);
    }
  }

  void removeLastFromStack() {
    _stackToastKey.currentState?.removeLast();
  }

  void clearFromStack() {
    _stackToastKey.currentState?.clear();
  }
}
