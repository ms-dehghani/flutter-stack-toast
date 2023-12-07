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
              'For show toast click bellow button',
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                StackToast.showToast(context, "$index");
                index++;
              },
              child: const Text("Show Toast"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                StackToast.clear(context);
              },
              child: const Text("clear"),
            ),
          ],
        ),
      ),
    );
  }
}
