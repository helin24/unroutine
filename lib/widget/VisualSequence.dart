import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:http/http.dart' as http;
import 'package:unroutine/database.dart';
import 'package:unroutine/util/constants.dart';
import 'package:unroutine/widget/TransitionsColumn.dart';
import 'package:unroutine/widget/saved.dart';
import 'dart:async';
import 'dart:convert';

const String apiUrl = 'http://unroutine-sequences.herokuapp.com/sequences/json';

class VisualSequence extends StatefulWidget {
  VisualSequence({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VisualSequenceState createState() => _VisualSequenceState();
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

class _VisualSequenceState extends State<VisualSequence> {
  Future<SequenceModel> sequence;
  bool clockwise = false;
  int count = 5;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      if (preferences.containsKey(CLOCKWISE_PREFERENCE)) {
        final clockwiseValue = preferences.getBool(CLOCKWISE_PREFERENCE);
        setState(() {
          clockwise = clockwiseValue;
        });
        sequence = fetchSequence(count, clockwise);
      }
    });
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.folder),
          onPressed: _pushSaved,
        ),
      ]),
      body: Center(
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
