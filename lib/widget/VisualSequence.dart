import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:http/http.dart' as http;
import 'package:unroutine/database.dart';
import 'package:unroutine/widget/TransitionsColumn.dart';
import 'package:unroutine/widget/saved.dart';
import 'dart:async';
import 'dart:convert';

const String apiUrl = 'http://unroutine-sequences.herokuapp.com/sequences/json';

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
  bool saved = false;

  @override
  void initState() {
    super.initState();
    sequence = fetchSequence(count, clockwise);
  }

  void _onRefresh() {
    setState(() {
      sequence = fetchSequence(count, clockwise);
      saved = false;
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) => Saved()));
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.folder),
              onPressed: _pushSaved,
            ),
          ]),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Number of steps'),
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Clockwise?'),
                Checkbox(
                  value: clockwise,
                  onChanged: (bool newValue) => setState(() {
                    clockwise = newValue;
                  }),
                ),
              ],
            ),
            FutureBuilder<SequenceModel>(
              future: sequence,
              builder: (context, sequence) {
                if (sequence.hasData) {
                  return getTransitionsColumn(sequence.data);
                } else if (sequence.hasError) {
                  return Text("${sequence.error}");
                }
                return CircularProgressIndicator();
              },
            ),
            saved
                ? Text('Saved!')
                : IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () {
                sequence.then((value) {
                  DatabaseProvider.db.insertSequence(value);
                  setState(() {
                    saved = true;
                  });
                });
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
