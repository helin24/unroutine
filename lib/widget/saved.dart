import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unroutine/database.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:unroutine/widget/text_display.dart';

class Saved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved sequences'),
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
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) => SequenceDetail(
                                sequence: sequences.data[index])));
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

class SequenceDetail extends StatelessWidget {
  final SequenceModel sequence;

  SequenceDetail({this.sequence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sequence.name),
      ),
      body: Center(
        child: TextDisplay(sequence: sequence, saved: true),
      ),
    );
  }
}
