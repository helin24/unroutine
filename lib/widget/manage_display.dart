import 'package:flutter/cupertino.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';

class ManageDisplay extends StatelessWidget {
  ManageDisplay({this.sequence, this.saved});

  final SequenceModel sequence;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    List<Text> children = [
      Text(sequence.startEdge.foot + sequence.startEdge.abbreviation)
    ] +
        sequence.transitions.map(getTransition).toList();

    if (saved) {
      children.add(Text(''));
      children.add(Text('Saved!'));
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
