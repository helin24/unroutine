import 'package:flutter/cupertino.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';

class ManageDisplay extends StatelessWidget {
  ManageDisplay({this.sequence, this.saved, this.onUnsave});

  final SequenceModel sequence;
  final bool saved;
  final Function() onUnsave;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (saved) {
      children.add(FlatButton(
        onPressed: onUnsave,
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
