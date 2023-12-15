import 'dart:math';

import 'package:flutter/material.dart';

import 'lib/toast_alignment.dart';

class FadeToastConfig {
  static FadeToastConfig? _singleton;

  factory FadeToastConfig() {
    _singleton ??= FadeToastConfig._internal();
    return _singleton!;
  }

  late double _horizontalMargin;
  late double _verticalMargin;

  late double _simpleItemHeight;

  late ToastAlignment _alignment;

  late BoxShadow _boxShadow;
  late BorderRadius _borderRadius;

  late Color _backgroundColor;

  late Duration _fadeAnimationDuration;

  FadeToastConfig._internal() {
    _backgroundColor = Colors.black;
    _borderRadius = const BorderRadius.all(Radius.circular(25.0));
    _fadeAnimationDuration = const Duration(milliseconds: 300);
    _boxShadow = const BoxShadow(
      color: Colors.black12,
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 1),
    );
    _horizontalMargin = 10;
    _verticalMargin = 10;
    _simpleItemHeight = 40;
    _alignment = ToastAlignment.bottom;
  }

  ToastAlignment get alignment {
    return _alignment;
  }

  double get horizontalMargin {
    return _horizontalMargin;
  }

  FadeToastConfig setHorizontalMargin(double horizontalMargin) {
    _horizontalMargin = max(horizontalMargin, 10);
    return this;
  }

  double get verticalMargin {
    return _verticalMargin;
  }

  FadeToastConfig setVerticalMargin(double verticalMargin) {
    _verticalMargin = max(verticalMargin, 10);
    return this;
  }

  double get simpleItemHeight {
    return _simpleItemHeight;
  }

  FadeToastConfig setSimpleItemHeight(double simpleItemHeight) {
    _simpleItemHeight = max(simpleItemHeight, 40);
    return this;
  }

  BoxShadow get boxShadow {
    return _boxShadow;
  }

  FadeToastConfig setBoxShadow(BoxShadow boxShadow) {
    _boxShadow = boxShadow;
    return this;
  }

  BorderRadius get borderRadius {
    return _borderRadius;
  }

  FadeToastConfig setBorderRadius(BorderRadius borderRadius) {
    _borderRadius = borderRadius;
    return this;
  }

  Color get backgroundColor {
    return _backgroundColor;
  }

  FadeToastConfig setBackgroundColor(Color backgroundColor) {
    _backgroundColor = backgroundColor;
    return this;
  }

  Duration get fadeAnimationDuration {
    return _fadeAnimationDuration;
  }

  FadeToastConfig setAnimationDuration(Duration animationDuration) {
    _fadeAnimationDuration = animationDuration;
    return this;
  }
}
