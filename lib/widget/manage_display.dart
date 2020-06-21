import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';

class ManageDisplay extends StatefulWidget {
  ManageDisplay({this.sequence, this.saved, this.onUnsave});

  final SequenceModel sequence;
  final bool saved;
  final Function() onUnsave;

  @override
  _ManageDisplayState createState() => _ManageDisplayState();
}

class _ManageDisplayState extends State<ManageDisplay> {
  double rating = 0;

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

Text getTransition(Transition transition) {
  return Text(
    transition.move.name +
        ' -> ' +
        transition.exit.foot +
        transition.exit.abbreviation,
  );
}
