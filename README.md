
## Features

1. Configurable toast view
2. Slide to dismiss
3. Auto dismissible
4. Can show custom widget as toast
5. Simple toast view
6. Stack toast view

## Getting started

Add this line to pubspec.yaml file:

```dart
    flutter_stack_toast: ^0.0.2
```

```dart
// add the import statement
import 'package:flutter_stack_toast/flutter_stack_toast.dart';

```

## Usage

For showing toast you have three methods in "FlutterToast" class:

show Simple Toast:
The only input needed in this method, is the text

```dart
 StackToast.showToast(buildContext, "desired text");
 ```

showTextToast:
You can customize your toast more with this method, using the whole Text widget instead of the String

```dart
 StackToast.showTextToast(buildContext, Text("desired text" , TextStyle(color: Colors.black, fontSize: 15)));
 ```

showCustomToast:
This one is the most customizable, allowing you to use any widget you prefer.

```dart
 StackToast.showCustomToast(buildContext, Text("desired text" , TextStyle(color: Colors.black, fontSize: 15)));
 ```

You can dismiss all showing and queued toast widgets with clear method:

```dart
 StackToast.clear(buildContext);
 ```

You can also change all the default configs:

```dart
FadeToastConfig()
  .setAlignment(ToastAlignment.bottom)
  .setHorizontalMargin(10)
  .setVerticalMargin(10)
  .setSimpleItemHeight(40)
  .setBoxShadow(BoxShadow(
    color: Colors.black12,
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 1),
    ))
  .setBorderRadius(BorderRadius.all(Radius.circular(12.0)))
  .setBackgroundColor(Colors.white)
  .setAnimationDuration(Duration(milliseconds: 300));
 ```

show Stack Toast:
The only input needed in this method, is the text

```dart
 StackToast.showStackToast(buildContext, "desired text");
 ```

showTextToast:
You can customize your toast more with this method, using the whole Text widget instead of the String

```dart
 StackToast.showStackTextToast(buildContext, Text("desired text" , TextStyle(color: Colors.black, fontSize: 15)));
 ```

showCustomToast:
This one is the most customizable, allowing you to use any widget you prefer.

```dart
 StackToast.showStackCustomToast(buildContext, Text("desired text" , TextStyle(color: Colors.black, fontSize: 15)));
 ```

You can dismiss all showing and queued toast widgets with clear method:

```dart
 StackToast.clearStackToast(buildContext);
 ```

You can also change all the default configs:

```dart
StackToastConfig()
  .setAlignment(ToastAlignment.bottom)
  .setHorizontalMargin(10)
  .setVerticalMargin(10)
  .setSimpleItemHeight(40)
  .setDownsizePercent(5)
  .setBetweenItemSpace(10)
  .setMaxShowingItem(5)
  .setDismissDirection(TextDirection.ltr)
  .setBoxShadow(BoxShadow(
    color: Colors.black12,
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 1),
    ))
  .setBorderRadius(BorderRadius.all(Radius.circular(12.0)))
  .setBackgroundColor(Colors.white)
  .setAnimationDuration(Duration(milliseconds: 300))
  .setAutoDismissItemDuration(Duration(seconds: 3))
  .setAutoDismissEnable(true);
 ```



