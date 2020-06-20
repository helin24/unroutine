import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:http/http.dart' as http;
import 'package:unroutine/database.dart';
import 'package:unroutine/widget/transitions_column.dart';
import 'package:unroutine/widget/saved.dart';
import 'dart:async';
import 'dart:convert';

const String apiUrl = 'http://unroutine-sequences.herokuapp.com/sequences/json';

class VisualSequence extends StatefulWidget {
  VisualSequence({Key key, this.title, this.sequence}) : super(key: key);

  final String title;
  final SequenceModel sequence;

  @override
  _VisualSequenceState createState() =>
      _VisualSequenceState(title: title, sequence: sequence);
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
  bool saved = false;
  final String title;
  final SequenceModel sequence;

  _VisualSequenceState({this.title, this.sequence});

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
            getTransitionsColumn(sequence),
            saved
                ? Text('Saved!')
                : IconButton(
                    icon: Icon(Icons.save_alt),
                    onPressed: () {
                      DatabaseProvider.db.insertSequence(sequence);
                      setState(() {
                        saved = true;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
