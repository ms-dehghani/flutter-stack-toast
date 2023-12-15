import 'dart:math';

import 'package:flutter/material.dart';

import 'lib/toast_alignment.dart';

class StackToastConfig {
  static StackToastConfig? _singleton;

  factory StackToastConfig() {
    _singleton ??= StackToastConfig._internal();
    return _singleton!;
  }

  late double _horizontalMargin;
  late double _verticalMargin;
  late double _downsizePercent;
  late double _betweenItemSpace;
  late double _simpleItemHeight;

  late int _maxShowingItem;

  late ToastAlignment _alignment;

  late TextDirection _dismissDirection;

  late BoxShadow _boxShadow;
  late BorderRadius _borderRadius;

  late Color _backgroundColor;

  late Duration _animationDuration;
  late Duration _showingItemDuration;

  late bool _autoDismissEnable;

  StackToastConfig._internal() {
    _backgroundColor = Colors.white;
    _borderRadius = const BorderRadius.all(Radius.circular(12.0));
    _animationDuration = const Duration(milliseconds: 300);
    _showingItemDuration = const Duration(seconds: 3);
    _boxShadow = const BoxShadow(
      color: Colors.black12,
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 1),
    );
    _horizontalMargin = 10;
    _verticalMargin = 10;
    _downsizePercent = 5;
    _betweenItemSpace = 10;
    _dismissDirection = TextDirection.ltr;
    _maxShowingItem = 5;
    _simpleItemHeight = 40;
    _autoDismissEnable = true;
    _alignment = ToastAlignment.bottom;
  }

  StackToastConfig setAlignment(ToastAlignment alignment) {
    _alignment = alignment;
    return this;
  }

  ToastAlignment get alignment {
    return _alignment;
  }

  double get horizontalMargin {
    return _horizontalMargin;
  }

  StackToastConfig setHorizontalMargin(double horizontalMargin) {
    _horizontalMargin = max(horizontalMargin, 10);
    return this;
  }

  double get verticalMargin {
    return _verticalMargin;
  }

  StackToastConfig setVerticalMargin(double verticalMargin) {
    _verticalMargin = max(verticalMargin, 10);
    return this;
  }

  double get simpleItemHeight {
    return _simpleItemHeight;
  }

  StackToastConfig setSimpleItemHeight(double simpleItemHeight) {
    _simpleItemHeight = max(simpleItemHeight, 40);
    return this;
  }

  double get downsizePercent {
    return _downsizePercent;
  }

  StackToastConfig setDownsizePercent(double downsizePercent) {
    _downsizePercent = max(downsizePercent, 0);
    return this;
  }

  double get betweenItemSpace {
    return _betweenItemSpace;
  }

  StackToastConfig setBetweenItemSpace(double betweenItemSpace) {
    _betweenItemSpace = max(betweenItemSpace, 0);
    return this;
  }

  int get maxShowingItem {
    return _maxShowingItem;
  }

  StackToastConfig setMaxShowingItem(int maxShowingItem) {
    _maxShowingItem = min(max(maxShowingItem, 1), 20);
    return this;
  }

  TextDirection get dismissDirection {
    return _dismissDirection;
  }

  StackToastConfig setDismissDirection(TextDirection dismissDirection) {
    _dismissDirection = dismissDirection;
    return this;
  }

  BoxShadow get boxShadow {
    return _boxShadow;
  }

  StackToastConfig setBoxShadow(BoxShadow boxShadow) {
    _boxShadow = boxShadow;
    return this;
  }

  BorderRadius get borderRadius {
    return _borderRadius;
  }

  StackToastConfig setBorderRadius(BorderRadius borderRadius) {
    _borderRadius = borderRadius;
    return this;
  }

  Color get backgroundColor {
    return _backgroundColor;
  }

  StackToastConfig setBackgroundColor(Color backgroundColor) {
    _backgroundColor = backgroundColor;
    return this;
  }

  Duration get animationDuration {
    return _animationDuration;
  }

  StackToastConfig setAnimationDuration(Duration animationDuration) {
    _animationDuration = animationDuration;
    return this;
  }

  Duration get showingItemDuration {
    return _showingItemDuration;
  }

  StackToastConfig setAutoDismissItemDuration(Duration showingItemDuration) {
    _showingItemDuration = showingItemDuration;
    return this;
  }

  bool get autoDismissEnable {
    return _autoDismissEnable;
  }

  StackToastConfig setAutoDismissEnable(bool autoDismissEnable) {
    _autoDismissEnable = autoDismissEnable;
    return this;
  }
}
