import 'package:flutter/cupertino.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  TextDisplay({this.sequence, this.saved});

  final SequenceModel sequence;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    List<Text> children =
        sequence.transitions.map((t) => getTransition(t, context)).toList();

    if (saved) {
      children.add(Text(''));
      children.add(Text('Saved!'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                sequence.startEdge.foot + sequence.startEdge.abbreviation,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }

  Text getTransition(Transition transition, BuildContext context) {
    return Text(
      transition.move.name +
          ' -> ' +
          transition.exit.foot +
          transition.exit.abbreviation,
      style: TextStyle(
        color: getTransitionColor(transition),
        fontSize: 28,
      ),
    );
  }

  Color getTransitionColor(Transition transition) {
    String word = transition.exit.foot + transition.exit.abbreviation[0];

    switch (word) {
      case 'LF':
        return Colors.lightGreen;
      case 'LB':
        return Colors.green;
      case 'RF':
        return Colors.orange;
      case 'RB':
        return Colors.deepOrange;
      default:
        return Colors.black;
    }
  }
}
