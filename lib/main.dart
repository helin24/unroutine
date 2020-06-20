import 'package:flutter/material.dart';
import 'package:unroutine/widget/user_settings.dart';
import 'package:unroutine/widget/generate_sequence.dart';

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
            GenerateSequence(title: 'Generate a sequence'),
      },
    );
  }
}
