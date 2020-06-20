import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:http/http.dart' as http;
import 'package:unroutine/database.dart';
import 'package:unroutine/widget/text_display.dart';
import 'package:unroutine/widget/saved.dart';
import 'dart:async';
import 'dart:convert';

const String apiUrl = 'http://unroutine-sequences.herokuapp.com/sequences/json';

class DisplaySequence extends StatefulWidget {
  DisplaySequence({Key key, this.title, this.sequence}) : super(key: key);

  final String title;
  final SequenceModel sequence;

  @override
  _DisplaySequenceState createState() =>
      _DisplaySequenceState(title: title, sequence: sequence);
}

class _DisplaySequenceState extends State<DisplaySequence> {
  bool saved = false;
  final String title;
  final SequenceModel sequence;

  _DisplaySequenceState({this.title, this.sequence});

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) => Saved()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.folder),
            onPressed: _pushSaved,
          ),
        ]),
        body: TabBarView(children: [
          TextDisplay(sequence: sequence, saved: saved),
          TextDisplay(sequence: sequence, saved: saved),
          TextDisplay(sequence: sequence, saved: saved),
        ]),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.font_download)),
            Tab(icon: Icon(Icons.remove_red_eye)),
            Tab(icon: Icon(Icons.hearing)),
          ],
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
        ),
        floatingActionButton: !saved
            ? FloatingActionButton(
                child: Icon(Icons.save_alt),
                tooltip: 'Save sequence',
                onPressed: () {
                  DatabaseProvider.db.insertSequence(sequence);
                  setState(() {
                    saved = true;
                  });
                },
              )
            : null,
      ),
    );
  }
}
