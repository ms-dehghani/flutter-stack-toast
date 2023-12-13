import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stack_toast/src/stack_toast_config.dart';

import 'alignment.dart';

class StackToastView extends StatefulWidget {
  final Function() removeAllCallback;
  final Function()? firstCallAfterBuild;

  const StackToastView(this.removeAllCallback, {this.firstCallAfterBuild, super.key});

  @override
  State<StackToastView> createState() => StackToastViewState();
}

class StackToastViewState extends State<StackToastView> with TickerProviderStateMixin {
  late final AnimationController _insertAnimationController = AnimationController(
    duration: StackToastConfig().animationDuration,
    vsync: this,
  );

  late final AnimationController _deleteAnimationController = AnimationController(
    duration: StackToastConfig().animationDuration,
    vsync: this,
  );

  late final AnimationController _dismissAllAnimationController = AnimationController(
    duration: StackToastConfig().animationDuration,
    vsync: this,
  );

  late final AnimationController _dismissAnimationController = AnimationController(
    duration: StackToastConfig().animationDuration,
    vsync: this,
  );

  final List<Widget> _widgetList = [];

  Timer? _dismissTimer;

  late double downsizePercent;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.firstCallAfterBuild != null && _widgetList.isEmpty) {
        widget.firstCallAfterBuild!.call();
      }
    });

    downsizePercent = StackToastConfig().downsizePercent / 100;

    _insertAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _insertAnimationController.reset();
        });
      }
    });

    _deleteAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _deleteAnimationController.reset();
        });
      }
    });

    _dismissAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _dismissAnimationController.reset();
        removeLast();
      }
    });

    _dismissAllAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _dismissAllAnimationController.reset();
          _dismissTimer?.cancel();
          _widgetList.clear();
          widget.removeAllCallback.call();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _insertAnimationController.dispose();
    _deleteAnimationController.dispose();
    _dismissAnimationController.dispose();
    _dismissAllAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var stack = SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: StackToastConfig().horizontalMargin,
            vertical: StackToastConfig().verticalMargin),
        child: Stack(
          alignment: _getAlignment(),
          children: listItems(),
        ),
      ),
    );

    return stack;
  }

  AlignmentGeometry _getAlignment() {
    switch (StackToastConfig().alignment) {
      case ToastAlignment.TOP:
        return Alignment.topCenter;
      case ToastAlignment.BOTTOM:
        return Alignment.bottomCenter;
      case ToastAlignment.CENTER:
        return Alignment.center;
    }
  }

  List<Widget> listItems() {
    List<Widget> list = [];
    int startPosition = max(0, _widgetList.length - 1 - StackToastConfig().maxShowingItem);
    for (int index = startPosition; index < _widgetList.length; index++) {
      var item = _widgetList[index];
      var itemIndex = _widgetList.length - 1 - index;
      list.add(_listItem(item, itemIndex));
    }
    return list;
  }

  Widget _listItem(Widget widget, int index) {
    var itemView = index == 0
        ? Dismissible(
            key: UniqueKey(),
            direction: _getDismissDirection(),
            onDismissed: (DismissDirection direction) {
              removeLast();
            },
            onUpdate: (details) {
              if (details.progress == 0.0) {
                _setTimer();
              } else {
                _dismissTimer?.cancel();
              }
            },
            child: widget,
          )
        : widget;

    var runningAnimation = getRunningAnimation();

    if (runningAnimation != null) {
      return _itemDuringAnimation(
          runningAnimation == _insertAnimationController, itemView, runningAnimation, index);
    } else {
      return Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(_animateX(true, null, index), _animateY(true, null, index), 0)
          ..scale(_itemScale(false, _insertAnimationController, index)),
        child: itemView,
      );
    }
  }

  DismissDirection _getDismissDirection() {
    return StackToastConfig().dismissDirection == TextDirection.rtl
        ? DismissDirection.startToEnd
        : DismissDirection.endToStart;
  }

  AnimationController? getRunningAnimation() {
    if (_insertAnimationController.isAnimating) {
      return _insertAnimationController;
    } else if (_deleteAnimationController.isAnimating) {
      return _deleteAnimationController;
    } else if (_dismissAnimationController.isAnimating) {
      return _dismissAnimationController;
    } else if (_dismissAllAnimationController.isAnimating) {
      return _dismissAllAnimationController;
    } else {
      return null;
    }
  }

  Widget _itemDuringAnimation(
      bool insert, Widget child, AnimationController controller, int index) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(
                _animateX(insert, controller, index), _animateY(insert, controller, index), 0)
            ..scale(_itemScale(insert, controller, index)),
          child: child,
        );
      },
    );
  }

  double _animateX(bool insert, AnimationController? controller, int index) {
    if (controller == null) {
      return 0;
    }
    if (controller == _dismissAllAnimationController) {
      double startPos = 0.07 * index;
      if (controller.value < startPos) return 0.0;
      return -((controller.value - startPos) * MediaQuery.of(context).size.width) *
          (StackToastConfig().dismissDirection == TextDirection.ltr ? 1.0 : -1.0);
    } else if (index == 0 && controller == _dismissAnimationController) {
      return -(controller.value * MediaQuery.of(context).size.width) *
          (StackToastConfig().dismissDirection == TextDirection.ltr ? 1 : -1);
    } else {
      return 0;
    }
  }

  double _animateY(bool insert, AnimationController? controller, int index) {
    if (controller == null) {
      return insert ? _itemEnterY(0.0, index) : _itemExitY(0.0, index);
    }
    if (controller == _dismissAllAnimationController || controller == _dismissAnimationController) {
      return _itemExitY(1, index);
    } else {
      return insert ? _itemEnterY(controller.value, index) : _itemExitY(controller.value, index);
    }
  }

  double _itemEnterY(double animation, int index) {
    double result = 0.0;
    int direction = StackToastConfig().alignment == ToastAlignment.TOP ? -1 : 1;
    if (index == 0) {
      double itemHeight = StackToastConfig().simpleItemHeight;
      double animationDistance = itemHeight + StackToastConfig().verticalMargin;
      result = _insertAnimationController.isAnimating
          ? (direction * itemHeight) - (animationDistance * animation * direction)
          : StackToastConfig().verticalMargin * -(direction);
      return result;
    } else {
      bool isShowTop = StackToastConfig().alignment == ToastAlignment.TOP;
      var startPosition = (StackToastConfig().verticalMargin * (isShowTop ? 1 : -1)) +
          StackToastConfig().betweenItemSpace *
              (isShowTop ? 1 : -1) *
              (_insertAnimationController.isAnimating ? index - 1 : index);
      result = startPosition +
          ((animation * StackToastConfig().betweenItemSpace) * (isShowTop ? 1 : -1));
    }
    return result;
  }

  double _itemExitY(double animation, int index) {
    bool isShowTop = StackToastConfig().alignment == ToastAlignment.TOP;
    var startPosition = (StackToastConfig().verticalMargin * (isShowTop ? 1 : -1)) +
        (((index + 1) * StackToastConfig().betweenItemSpace) * (isShowTop ? 1 : -1));
    var result =
        startPosition - ((isShowTop ? 1 : -1) * animation * StackToastConfig().betweenItemSpace);
    return result;
  }

  double _itemScale(bool insert, AnimationController controller, int index) {
    if (controller == _dismissAnimationController) {
      return _itemScaleDown(0, index);
    } else {
      return insert
          ? _itemScaleDown(controller.isAnimating ? controller.value : 1, index)
          : _itemScaleUp(controller.isAnimating ? controller.value : 1, index);
    }
  }

  double _itemScaleDown(double animation, int index) {
    if (index == 0) {
      return 1;
    }
    return (1 - ((index - (_insertAnimationController.isAnimating ? 1 : 0)) * downsizePercent)) -
        (animation * downsizePercent);
  }

  double _itemScaleUp(double animation, int index) {
    return (1 - ((index + 1) * downsizePercent)) + (animation * downsizePercent);
  }

  Widget _getSimpleView(Text text) {
    return Container(
      width: MediaQuery.of(context).size.width - (StackToastConfig().horizontalMargin * 2),
      height: StackToastConfig().simpleItemHeight,
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          boxShadow: [StackToastConfig().boxShadow],
          color: StackToastConfig().backgroundColor,
          borderRadius: StackToastConfig().borderRadius),
      child: text,
    );
  }

  bool isEmpty() {
    return _widgetList.isEmpty;
  }

  void addWidget({Widget? view, Text? text}) {
    if (view == null && text == null) {
      return;
    }
    setState(() {
      _setTimer();
      _widgetList.add(view ?? _getSimpleView(text!));
      _insertAnimationController.reset();
      _insertAnimationController.forward();
    });
  }

  bool removeLast() {
    if (_widgetList.isNotEmpty) {
      setState(() {
        _setTimer();
        _widgetList.removeLast();
        _deleteAnimationController.reset();
        _deleteAnimationController.forward();
      });
    } else {
      widget.removeAllCallback.call();
    }
    return _widgetList.isNotEmpty;
  }

  void _setTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer.periodic(StackToastConfig().showingItemDuration, (timer) {
      setState(() {
        _dismissAnimationController.forward();
      });
    });
  }

  void clear() {
    setState(() {
      _dismissAllAnimationController.forward();
    });
  }
}
