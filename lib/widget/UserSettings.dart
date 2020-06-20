import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool clockwise = false;
  SharedPreferences preferences;
  static const String CLOCKWISE = 'clockwise';

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((newPreferences) {
      preferences = newPreferences;
      if (preferences.containsKey(CLOCKWISE)) {
        setState(() {
          clockwise = preferences.getBool(CLOCKWISE);
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
          ],
        ),
      ),
    );
  }

  onClockwiseChanged(bool newValue) {
    setState(() {
      clockwise = newValue;
    });
    preferences.setBool(CLOCKWISE, newValue);
  }
}
