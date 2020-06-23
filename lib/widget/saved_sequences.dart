import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unroutine/database.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:unroutine/widget/display_sequence.dart';
import 'package:unroutine/widget/popup_menu.dart';
import 'package:unroutine/widget/text_display.dart';

class SavedSequences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved sequences'),
        actions: <Widget>[
          PopupMenu('Saved sequences', MenuItemKey.SAVED_VIDEO),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<SequenceModel>>(
          future: DatabaseProvider.db.sequences(),
          builder: (BuildContext context,
              AsyncSnapshot<List<SequenceModel>> sequences) {
            if (sequences.hasData) {
              return ListView.builder(
                  itemCount: sequences.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(sequences.data[index].name),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => DisplaySequence(
                                sequence: sequences.data[index]),
                          ),
                        );
                      },
                    );
                  });
            } else if (sequences.hasError) {
              return Text("${sequences.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
