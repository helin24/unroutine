import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://unroutine-sequences.herokuapp.com/ratesequence';

Future<bool> submitRating(
  int sequenceId,
  double rating,
) async {
  final url = apiUrl;
  final response = await http.post(
    url,
    body: {
      'sequenceId': sequenceId.toString(),
      'rating': rating.toString(),
    },
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

class ManageDisplay extends StatefulWidget {
  ManageDisplay({this.sequence, this.saved, this.onUnsave});

  final SequenceModel sequence;
  final bool saved;
  final Function() onUnsave;

  @override
  _ManageDisplayState createState() =>
      _ManageDisplayState(sequenceId: sequence.id);
}

class _ManageDisplayState extends State<ManageDisplay> {
  double rating = 0;
  final int sequenceId;

  _ManageDisplayState({this.sequenceId});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(RatingBar(
      initialRating: rating,
      direction: Axis.horizontal,
      itemCount: 4,
      ratingWidget: RatingWidget(
        full: Icon(Icons.star),
        half: Icon(Icons.star),
        empty: Icon(Icons.star_border),
      ),
      onRatingUpdate: (rating) {
        setState(() {
          rating = rating;
        });
        submitRating(sequenceId, rating).then((saved) {
          if (!saved) {
            print('did not save');
          }
        });
      },
    ));

    if (widget.saved) {
      children.add(FlatButton(
        onPressed: widget.onUnsave,
        child: Text('Unsave'),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
