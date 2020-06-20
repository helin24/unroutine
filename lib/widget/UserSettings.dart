import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

const String CLOCKWISE_PREFERENCE = 'clockwise';
const String LEVEL_PREFERENCE = 'level';
// TODO: These should probably come from server eventually
const List<String> levels = ['Pre-bronze', 'Bronze', 'Silver', 'Gold'];

class _UserSettingsState extends State<UserSettings> {
  bool clockwise = false;
  SharedPreferences preferences;
  String level = levels[0];

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((newPreferences) {
      preferences = newPreferences;

      if (preferences.containsKey(CLOCKWISE_PREFERENCE)) {
        setState(() {
          clockwise = preferences.getBool(CLOCKWISE_PREFERENCE);
        });
      }

      if (preferences.containsKey(LEVEL_PREFERENCE)) {
        setState(() {
          level = preferences.getString(LEVEL_PREFERENCE);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unroutine settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User settings'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Clockwise?'),
                Checkbox(
                  value: clockwise,
                  onChanged: onClockwiseChanged,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Level '),
                DropdownButton<String>(
                  value: level,
                  onChanged: onLevelChanged,
                  items: levels.map(
                    (String level) => DropdownMenuItem<String>(
                      value: level,
                      child: Text(level),
                    ),
                  ).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onClockwiseChanged(bool newValue) {
    setState(() {
      clockwise = newValue;
    });
    preferences.setBool(CLOCKWISE_PREFERENCE, newValue);
  }

  onLevelChanged(String newValue) {
    setState(() {
      level = newValue;
    });
    preferences.setString(LEVEL_PREFERENCE, newValue);
  }
}
