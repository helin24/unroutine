import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';

Widget getTransitionsColumn(SequenceModel sequence) {
  List<Text> children =
      [Text(sequence.startEdge.foot + sequence.startEdge.abbreviation)] +
          sequence.transitions
              .map((Transition transition) => Text(
                    transition.move.name +
                        ' -> ' +
                        transition.exit.foot +
                        transition.exit.abbreviation,
                  ))
              .toList();
  return Column(
      mainAxisAlignment: MainAxisAlignment.center, children: children);
}
