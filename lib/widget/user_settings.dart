import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unroutine/util/constants.dart';
import 'package:unroutine/widget/popup_menu.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool clockwise = false;
  SharedPreferences preferences;
  String level = levels[0].abbreviation;

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
        actions: <Widget>[
          PopupMenu('Settings', MenuItemKey.SETTINGS),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Rotation direction',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rotate_left,
                  color: clockwise
                      ? Theme.of(context).disabledColor
                      : Colors.orange,
                ),
                Switch(
                  value: clockwise,
                  onChanged: onClockwiseChanged,
                  activeColor: Colors.green,
                  activeTrackColor: Colors.lightGreen,
                  inactiveThumbColor: Colors.orange,
                  inactiveTrackColor: Colors.orangeAccent,
                ),
                Icon(
                  Icons.rotate_right,
                  color: clockwise
                      ? Colors.green
                      : Theme.of(context).disabledColor,
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 2),
                Text(
                  'Level',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacer(),
                DropdownButton<String>(
                  value: level,
                  onChanged: onLevelChanged,
                  items: levels
                      .map(
                        (Level level) => DropdownMenuItem<String>(
                          value: level.abbreviation,
                          child: Text(
                            level.name,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Spacer(flex: 2),
              ],
            ),
            Divider(),
            ElevatedButton(
              onPressed: onGeneratePressed,
              child: Text(
                'Generate',
                style: TextStyle(fontSize: 24),
              ),
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

  onGeneratePressed() {
    Navigator.pushNamed(context, '/generate');
  }
}
