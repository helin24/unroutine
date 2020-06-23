import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unroutine/widget/saved_sequences.dart';
import 'package:unroutine/widget/saved_videos.dart';
import 'package:unroutine/widget/user_settings.dart';
import 'package:unroutine/widget/generate_sequence.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;
  bool hasSettings;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        loading = false;
        hasSettings = preferences.getKeys().length > 0;
      });
    });
  }

  Widget _getHome() {
    if (loading) {
      return CircularProgressIndicator();
    }

    return hasSettings
        ? GenerateSequence(title: 'Generate a sequence')
        : UserSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unroutine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getHome(),
      routes: <String, WidgetBuilder>{
        '/generate': (BuildContext context) =>
            GenerateSequence(title: 'Generate a sequence'),
        '/settings': (BuildContext context) => UserSettings(),
        '/saved_sequences': (BuildContext context) => SavedSequences(),
        '/saved_videos': (BuildContext context) => SavedVideos(),
      },
    );
  }
}
