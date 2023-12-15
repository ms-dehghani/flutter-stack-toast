import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stack_toast/src/fade_toast_config.dart';

import 'toast_alignment.dart';

class SimpleToastView extends StatefulWidget {
  final Function() removeAllCallback;
  final Function()? firstCallAfterBuild;

  const SimpleToastView(this.removeAllCallback, {this.firstCallAfterBuild, super.key});

  @override
  State<SimpleToastView> createState() => SimpleToastViewState();
}

class SimpleToastViewState extends State<SimpleToastView> {
  final Map<Widget, Duration> _widgetList = {};

  bool _visible = false;

  Timer? _showingTimer;
  Timer? _fadeTimer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.firstCallAfterBuild != null && _widgetList.isEmpty) {
        widget.firstCallAfterBuild!.call();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    _showingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var stack = SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: FadeToastConfig().horizontalMargin,
            vertical: FadeToastConfig().verticalMargin),
        child: Align(
          alignment: _getAlignment(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [showItem()],
          ),
        ),
      ),
    );

    return stack;
  }

  AlignmentGeometry _getAlignment() {
    switch (FadeToastConfig().alignment) {
      case ToastAlignment.top:
        return Alignment.topCenter;
      case ToastAlignment.bottom:
        return Alignment.bottomCenter;
      case ToastAlignment.center:
        return Alignment.center;
    }
  }

  Widget showItem() {
    if (_widgetList.isEmpty) {
      _visible = false;
      return Container();
    }

    Widget widget = _widgetList.keys.first;
    Duration duration = _widgetList[widget]!;

    if (_visible) {
      _setShowTimer(duration);
    } else {
      _setHideTimer();
    }

    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: FadeToastConfig().fadeAnimationDuration,
      child: widget,
    );
  }

  Widget _getSimpleView(Text text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: FadeToastConfig().simpleItemHeight),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              boxShadow: [FadeToastConfig().boxShadow],
              color: FadeToastConfig().backgroundColor,
              borderRadius: FadeToastConfig().borderRadius),
          child: text,
        )
      ],
    );
  }

  bool isEmpty() {
    return _widgetList.isEmpty;
  }

  void addWidget(Duration duration, {Widget? view, Text? text}) {
    if (view == null && text == null) {
      return;
    }
    _widgetList.putIfAbsent(view ?? _getSimpleView(text!), () => duration);
    if (_widgetList.length == 1 && !_visible) {
      setState(() {
        _visible = true;
      });
    }
  }

  bool removeFirst() {
    if (_widgetList.isNotEmpty) {
      setState(() {
        _widgetList.remove(_widgetList.keys.first);
        _visible = true;
      });
    } else {
      widget.removeAllCallback.call();
    }
    return _widgetList.isNotEmpty;
  }

  void _setShowTimer(Duration duration) {
    _showingTimer?.cancel();
    _showingTimer = Timer(duration, () {
      setState(() {
        _visible = false;
      });
    });
  }

  void _setHideTimer() {
    _fadeTimer?.cancel();
    _fadeTimer = Timer(FadeToastConfig().fadeAnimationDuration, () {
      removeFirst();
    });
  }

  void clear() {
    setState(() {
      while (_widgetList.length > 1) {
        _widgetList.remove(_widgetList.keys.toList()[1]);
      }
      _visible = false;
    });
  }
}
