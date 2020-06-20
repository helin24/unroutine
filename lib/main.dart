import 'package:flutter/material.dart';
import 'package:unroutine/widget/UserSettings.dart';
import 'package:unroutine/widget/VisualSequence.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unroutine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserSettings(),
      routes: <String, WidgetBuilder>{
        '/generate': (BuildContext context) =>
            VisualSequence(title: 'Generate a sequence'),
      },
    );
  }
}
