import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stack_toast/flutter_stack_toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  OverlayState? overlay;

  List<OverlayEntry> list = [];

  List<IconData> icons = [
    Icons.reset_tv_outlined,
    Icons.add_alert_outlined,
    Icons.woo_commerce,
    Icons.h_mobiledata,
    Icons.golf_course,
    Icons.do_disturb_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    overlay ??= Overlay.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'To display the toast, click one of the buttons below:',
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                StackToast.showToast(context, "It is the toast number $index");
                index++;
              },
              child: const Text("Show Basic Toast"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                StackToast.showTextToast(
                    context,
                    Text(
                      "It is the toast number $index",
                      style: const TextStyle(
                        color: Colors.amber,
                        letterSpacing: 5,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ));
                index++;
              },
              child: const Text("Show Text Toast"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                StackToast.showCustomToast(
                    context,
                    Container(
                      width: 300,
                      height: 50,
                      color: Colors.amber,
                      child: Icon(
                        icons[Random().nextInt(icons.length)],
                        color: Colors.white,
                      ),
                    ));
                index++;
              },
              child: const Text("Show Custom Toast"),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'To clear all the toasts, click the button below:',
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                StackToast.clear(context);
              },
              child: const Text("Clear"),
            ),
          ],
        ),
      ),
    );
  }
}
