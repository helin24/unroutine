import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:http/http.dart' as http;
import 'package:unroutine/util/constants.dart';
import 'package:unroutine/widget/popup_menu.dart';
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

Future<SequenceModel> fetchSequence(
  int steps,
  bool clockwise,
  bool stepSequence,
  String level,
) async {
  final url = apiUrl +
      '?steps=' +
      steps.toString() +
      '&clockwise=' +
      (clockwise ? 'on' : 'off') +
      '&stepSequence=' +
      (stepSequence ? 'on' : 'off') +
      '&level=' +
      level;
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return SequenceModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load sequence');
  }
}

class _GenerateSequenceState extends State<GenerateSequence> {
  bool clockwise = false;
  bool stepSequence = true;
  String level = levels[0].abbreviation;
  int count = 6;
  bool pressed = false;
  SequenceModel sequence;
//  TextEditingController _countController;

  @override
  void initState() {
    super.initState();
//    _countController = new TextEditingController(
//      text: count.toString(),
//    );
    SharedPreferences.getInstance().then((preferences) {
      if (preferences.containsKey(CLOCKWISE_PREFERENCE)) {
        final clockwiseValue = preferences.getBool(CLOCKWISE_PREFERENCE);
        setState(() {
          clockwise = clockwiseValue;
        });
      }
      if (preferences.containsKey(LEVEL_PREFERENCE)) {
        setState(() {
          level = preferences.getString(LEVEL_PREFERENCE);
        });
      }
    });
  }

  void _onGeneratePressed() {
    setState(() {
      pressed = true;
    });
    fetchSequence(count, clockwise, stepSequence, level).then((result) {
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
                Spacer(flex: 2),
                Text('Number of steps'),
                Spacer(flex: 1),
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: count > 4
                      ? () => setState(() {
                            count -= 1;
                          })
                      : null,
                ),
                Text(count.toString()),
//                Expanded(
//                  child: TextField(
//                    keyboardType: TextInputType.number,
//                    controller: _countController,
//                    onChanged: (value) {
//                      int intValue = int.parse(value);
//                      if (intValue == null || intValue < 4 || intValue > 18) {
//                        return;
//                      }
//                      setState(() {
//                        count = intValue;
//                      });
//                    },
//                  ),
//                ),
                IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: count < 18
                        ? () => setState(() {
                              count += 1;
                            })
                        : null),
                Spacer(flex: 2),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Step sequence?'),
                Checkbox(
                  value: stepSequence,
                  onChanged: onStepSequenceChanged,
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

  onStepSequenceChanged(bool newValue) {
    setState(() {
      stepSequence = newValue;
    });
  }
}
