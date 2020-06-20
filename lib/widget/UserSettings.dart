
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unroutine settings'),
      ),
      body: Center(
        child: Text('User settings'),
      ),
    );
  }

}