import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:unroutine/database.dart';
import 'package:unroutine/widget/audio_display.dart';
import 'package:unroutine/widget/manage_display.dart';
import 'package:unroutine/widget/popup_menu.dart';
import 'package:unroutine/widget/text_display.dart';

import 'package:unroutine/widget/visual_display.dart';

import 'camera_display.dart';

class DisplaySequence extends StatefulWidget {
  DisplaySequence({Key key, this.sequence, this.saved = false}) : super(key: key);

  final SequenceModel sequence;
  final bool saved;

  @override
  _DisplaySequenceState createState() =>
      _DisplaySequenceState(sequence: sequence, saved: saved);
}

class _DisplaySequenceState extends State<DisplaySequence> {
  bool saved = false;
  final String title = 'Generated';
  final SequenceModel sequence;

  _DisplaySequenceState({this.sequence, this.saved});

  void _onUnsave() {
    setState(() {
      saved = false;
    });
    // TODO: Remove from database when database is restructured to allow deletes.
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            PopupMenu('Sequence', MenuItemKey.GENERATE),
          ],
        ),
        body: TabBarView(children: [
          TextDisplay(sequence: sequence, saved: saved),
          VisualDisplay(sequence: sequence, saved: saved),
          AudioDisplay(sequence: sequence, saved: saved),
          ManageDisplay(
            sequence: sequence,
            saved: saved,
            onUnsave: _onUnsave,
          ),
          CameraDisplay(sequence: sequence),
        ]),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.font_download)),
            Tab(icon: Icon(Icons.remove_red_eye)),
            Tab(icon: Icon(Icons.hearing)),
            Tab(icon: Icon(Icons.settings)),
            Tab(icon: Icon(Icons.videocam)),
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
