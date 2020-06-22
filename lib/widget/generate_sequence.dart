import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:http/http.dart' as http;
import 'package:unroutine/util/constants.dart';
import 'package:unroutine/widget/popup_menu.dart';
import 'package:unroutine/widget/saved.dart';
import 'dart:async';
import 'dart:convert';

import 'package:unroutine/widget/display_sequence.dart';

const String apiUrl = 'http://unroutine-sequences.herokuapp.com/sequences/json';

class GenerateSequence extends StatefulWidget {
  GenerateSequence({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GenerateSequenceState createState() => _GenerateSequenceState();
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

class _GenerateSequenceState extends State<GenerateSequence> {
  bool clockwise = false;
  int count = 5;
  bool pressed = false;
  SequenceModel sequence;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      if (preferences.containsKey(CLOCKWISE_PREFERENCE)) {
        final clockwiseValue = preferences.getBool(CLOCKWISE_PREFERENCE);
        setState(() {
          clockwise = clockwiseValue;
        });
      }
    });
  }

  void _onGeneratePressed() {
    setState(() {
      pressed = true;
    });
    fetchSequence(count, clockwise).then((result) {
      setState(() {
        pressed = false;
        sequence = result;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => DisplaySequence(
            sequence: result,
          ),
        ),
      );
    });
  }

  void _onReturnPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => DisplaySequence(
          sequence: sequence,
        ),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) => Saved()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        PopupMenu('Title', MenuItemKey.GENERATE),
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
            pressed
                ? CircularProgressIndicator()
                : FlatButton(
                    onPressed: _onGeneratePressed,
                    child: Text('Generate new'),
                  ),
          ],
        ),
      ),
      floatingActionButton: sequence != null
          ? FloatingActionButton(
              onPressed: _onReturnPressed,
              tooltip: 'Return to previous sequence',
              child: Icon(Icons.arrow_forward),
            )
          : null,
    );
  }
}
