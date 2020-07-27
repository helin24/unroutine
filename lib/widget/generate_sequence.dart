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
  int minId,
) async {
  final url = apiUrl +
      '?steps=' +
      steps.toString() +
      '&clockwise=' +
      (clockwise ? 'on' : 'off') +
      '&stepSequence=' +
      (stepSequence ? 'on' : 'off') +
      '&level=' +
      level +
      '&minId=' +
      minId.toString();
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return SequenceModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load sequence');
  }
}

String minIdKey(String level, bool stepSequence) {
  final String stepSeqStr = stepSequence ? 'STEP' : 'NONSTEP';
  return '${level}_${stepSeqStr}_minId';
}

class _GenerateSequenceState extends State<GenerateSequence> {
  bool clockwise = false;
  bool stepSequence = true;
  String level = levels[0].abbreviation;
  int minId = 0;
  int count = 6;
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
    final String key = minIdKey(level, stepSequence);
    SharedPreferences.getInstance().then((preferences) {
      if (preferences.containsKey(key)) {
        return preferences.getInt(key);
      } else {
        return minId;
      }
    }).then((minId) {
      return fetchSequence(count, clockwise, stepSequence, level, minId);
    }).then((result) {
      setState(() {
        pressed = false;
        sequence = result;
      });
      SharedPreferences.getInstance().then((preferences) {
        preferences.setInt(key, result.id + 1);
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
          children: <Widget>[
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 2),
                Text(
                  'Number of steps',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacer(flex: 1),
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: count > 4
                      ? () => setState(() {
                            count -= 1;
                          })
                      : null,
                ),
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.headline5,
                ),
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
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Step sequence?',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Checkbox(
                  value: stepSequence,
                  onChanged: onStepSequenceChanged,
                ),
              ],
            ),
            Divider(),
            pressed
                ? CircularProgressIndicator()
                : RaisedButton(
                    onPressed: _onGeneratePressed,
                    child: Text(
                      'Generate new',
                      style: TextStyle(fontSize: 24),
                    ),
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
