import 'package:flutter/material.dart';

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

  late final Alignment _alignment = Alignment.bottomCenter;
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
  }

  Alignment get alignment {
    return _alignment;
  }

  double get horizontalMargin {
    return _horizontalMargin;
  }

  StackToastConfig setHorizontalMargin(double horizontalMargin) {
    _horizontalMargin = horizontalMargin;
    return this;
  }

  double get verticalMargin {
    return _verticalMargin;
  }

  StackToastConfig setVerticalMargin(double verticalMargin) {
    _verticalMargin = verticalMargin;
    return this;
  }

  double get simpleItemHeight {
    return _simpleItemHeight;
  }

  StackToastConfig setSimpleItemHeight(double simpleItemHeight) {
    _simpleItemHeight = simpleItemHeight;
    return this;
  }

  double get downsizePercent {
    return _downsizePercent;
  }

  StackToastConfig setDownsizePercent(double downsizePercent) {
    _downsizePercent = downsizePercent;
    return this;
  }

  double get betweenItemSpace {
    return _betweenItemSpace;
  }

  StackToastConfig setBetweenItemSpace(double betweenItemSpace) {
    _betweenItemSpace = betweenItemSpace;
    return this;
  }

  int get maxShowingItem {
    return _maxShowingItem;
  }

  StackToastConfig setMaxShowingItem(int maxShowingItem) {
    _maxShowingItem = maxShowingItem;
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
