import 'package:flutter/material.dart';
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
      home: VisualSequence(title: 'Unroutine Home Page'),
    );
  }
}
