import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ParentWidget(),
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  void callChildMethod() {
    // This method will be called from the button press
    // You can call any method in ChildWidget or pass data to it.
    childKey.currentState?.performChildMethod();
  }

  GlobalKey<ChildWidgetState> childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Widget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: callChildMethod,
              child: Text('Call Child Method'),
            ),
            ChildWidget(key: childKey),
          ],
        ),
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  const ChildWidget({Key? key}) : super(key: key);

  @override
  ChildWidgetState createState() => ChildWidgetState();
}

class ChildWidgetState extends State<ChildWidget> {
  void performChildMethod() {
    // This method can be called from the parent widget
    print('Child Method Called');
    // Add your logic here
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Child Widget'),
    );
  }
}
