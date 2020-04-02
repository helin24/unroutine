import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unroutine/model/sequence_model.dart';
import 'dart:async';
import 'dart:convert';

const String apiUrl = 'http://unroutine-sequences.herokuapp.com/sequences/json';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unroutine',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Unroutine Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<SequenceModel> fetchSequence(int steps, bool clockwise) async {
  final url = apiUrl +
      '?steps=' +
      steps.toString() +
      '&clockwise=' +
      (clockwise ? 'on' : 'off');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return SequenceModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load sequence');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SequenceModel> sequence;
  bool clockwise = false;
  int count = 5;

  @override
  void initState() {
    super.initState();
    sequence = fetchSequence(count, clockwise);
  }

  void _onRefresh() {
    setState(() {
      sequence = fetchSequence(count, clockwise);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            DropdownButton<int>(
              value: count,
              onChanged: (int newValue) => setState(() {
                count = newValue;
              }),
              items: Iterable<int>.generate(20).map((int num) {
                return DropdownMenuItem<int>(
                    value: num + 1, child: Text((num + 1).toString()));
              }).toList(),
            ),
            Checkbox(
              value: clockwise,
              onChanged: (bool newValue) => setState(() {
                clockwise = newValue;
              }),
            ),
            FutureBuilder<SequenceModel>(
              future: sequence,
              builder: (context, sequence) {
                if (sequence.hasData) {
                  List<Text> children = [Text(sequence.data.startEdge.name)] +
                      sequence.data.transitions
                          .map((Transition transition) => Text(
                              transition.move.name +
                                  ' -> ' +
                                  transition.exit.abbreviation))
                          .toList();
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children);
                } else if (sequence.hasError) {
                  return Text("${sequence.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onRefresh,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
