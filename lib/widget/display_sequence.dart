import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:unroutine/database.dart';
import 'package:unroutine/widget/audio_display.dart';
import 'package:unroutine/widget/manage_display.dart';
import 'package:unroutine/widget/text_display.dart';
import 'package:unroutine/widget/saved.dart';

import 'package:unroutine/widget/visual_display.dart';

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

  void _onUnsave() {
    setState(() {
      saved = false;
    });
    // TODO: Remove from database when database is restructured to allow deletes.
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.folder),
            onPressed: _pushSaved,
          ),
        ]),
        body: TabBarView(children: [
          TextDisplay(sequence: sequence, saved: saved),
          VisualDisplay(sequence: sequence, saved: saved),
          AudioDisplay(sequence: sequence, saved: saved),
          ManageDisplay(sequence: sequence, saved: saved, onUnsave: _onUnsave,),
        ]),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.font_download)),
            Tab(icon: Icon(Icons.remove_red_eye)),
            Tab(icon: Icon(Icons.hearing)),
            Tab(icon: Icon(Icons.settings)),
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
