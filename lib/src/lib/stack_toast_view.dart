import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stack_toast/src/stack_toast_config.dart';

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
    var stack = Padding(
      padding: EdgeInsets.only(bottom: StackToastConfig().horizontalMargin),
      child: Stack(
        alignment: StackToastConfig().alignment,
        children: listItems(),
      ),
    );

    return stack;
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
            direction: DismissDirection.horizontal,
            onDismissed: (DismissDirection direction) {
              removeLast();
            },
            onUpdate: (details) {
              _dismissTimer?.cancel();
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
          ..translate(0.0, _animateY(true, _insertAnimationController, index), 0)
          ..scale(_itemScale(false, _insertAnimationController, index)),
        child: itemView,
      );
    }
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
            ..translate(_animateX(controller, index), _animateY(insert, controller, index), 0)
            ..scale(_itemScale(insert, controller, index)),
          child: child,
        );
      },
    );
  }

  double _animateX(AnimationController controller, int index) {
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

  double _animateY(bool insert, AnimationController controller, int index) {
    if (controller == _dismissAllAnimationController || controller == _dismissAnimationController) {
      return _itemExit(1, index);
    } else {
      return insert ? _itemEnter(controller.value, index) : _itemExit(controller.value, index);
    }
  }

  double _itemEnter(double animation, int index) {
    if (index == 0) {
      double itemHeight = StackToastConfig().simpleItemHeight;
      double animationDistance = itemHeight + StackToastConfig().verticalMargin;
      var result = _insertAnimationController.isAnimating
          ? itemHeight - (animationDistance * animation)
          : -StackToastConfig().verticalMargin;
      return result;
    } else {
      double startPosition = -StackToastConfig().verticalMargin -
          ((index - (_insertAnimationController.isAnimating ? 1 : 0)) *
              StackToastConfig().betweenItemSpace);
      var result = startPosition - (animation * StackToastConfig().betweenItemSpace);
      return result;
    }
  }

  double _itemExit(double animation, int index) {
    double startPosition =
        -StackToastConfig().verticalMargin - ((index + 1) * StackToastConfig().betweenItemSpace);
    var result = startPosition + (animation * StackToastConfig().betweenItemSpace);
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
