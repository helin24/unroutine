import 'package:flutter/cupertino.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';
import 'package:unroutine/widget/visual_transitions.dart';

class VisualDisplay extends StatelessWidget {
  VisualDisplay({this.sequence, this.saved});

  final SequenceModel sequence;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SequencePainter(context: context, sequence: sequence),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
//            Text(
//              'Example sequence',
//              style: TextStyle(
//                fontSize: 40.0,
//                fontWeight: FontWeight.w900,
//                color: Theme.of(context).textTheme.bodyText1.color,
//              ),
//            ),
            Text(saved ? 'Saved!' : ''),
          ],
        ),
      ),
    );
  }
}

class SequencePainter extends CustomPainter {
  SequencePainter({this.context, this.sequence}) {
    _leftPaint = Paint();
    _leftPaint.color = Colors.lightGreen;
    _leftPaint.strokeWidth = 4;
    _leftPaint.style = PaintingStyle.stroke;

    // TODO: Need a better way to distinguish backward vs. forward
    _leftBackPaint = Paint();
    _leftBackPaint.color = Colors.green;
    _leftBackPaint.strokeWidth = 3;
    _leftBackPaint.style = PaintingStyle.stroke;

    _rightPaint = Paint();
    _rightPaint.color = Colors.orange;
    _rightPaint.strokeWidth = 4;
    _rightPaint.style = PaintingStyle.stroke;

    _rightBackPaint = Paint();
    _rightBackPaint.color = Colors.deepOrange;
    _rightBackPaint.strokeWidth = 3;
    _rightBackPaint.style = PaintingStyle.stroke;

    _debugPaint = Paint();
    _debugPaint.color = Colors.black;
    _debugPaint.strokeWidth = 1;
  }

  final BuildContext context;
  final SequenceModel sequence;
  Paint _leftPaint;
  Paint _leftBackPaint;
  Paint _rightPaint;
  Paint _rightBackPaint;
  Paint _debugPaint;

  @override
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset(60, 40);
    double direction = 0;

    // Starting position
    final firstTransition = sequence.transitions.first;
    canvas.drawCircle(
      offset,
      5,
      getPaint(
        firstTransition.entry.foot,
        firstTransition.entry.abbreviation,
      ),
    );

    for (var transition in sequence.transitions) {
      EndPoint result = drawTransition(canvas, transition, offset, direction);
      offset = result.offset;
      direction = result.direction;

      canvas.drawCircle(offset, 3, getDebugPaint());
    }
  }

  // Travel direction will be 0 for moving to the right, pi/2 for moving down, etc.
  EndPoint drawTransition(Canvas canvas, Transition transition, Offset start,
      double travelDirection) {
    print('drawing transition starting at (${start.dx}, ${start.dy})');
    Offset endOffset;
    if (transition.move.abbreviation == 'Spiral') {
      return drawSpiral(canvas, transition, start, travelDirection, getPaint);
    } else if (transition.move.abbreviation == 'Step') {
      if (transition.entry.abbreviation[0] == transition.exit.abbreviation[0] && transition.entry.abbreviation[1] != transition.exit.abbreviation[1]) {
        return drawContinueStep(canvas, transition, start, travelDirection, getPaint);
      }
      return drawStep(canvas, transition, start, travelDirection, getPaint);
    } else if (transition.move.abbreviation == 'PwPull') {
      return drawPowerPull(
          canvas, transition, start, travelDirection, getPaint);
    } else if (transition.move.abbreviation == '3Turn') {
      return drawThreeTurn(
          canvas, transition, start, travelDirection, getPaint);
    } else if (transition.move.abbreviation == 'Loop') {
      return drawLoop(
          canvas, transition, start, travelDirection, getPaint);
    } else {
      canvas.drawCircle(
        start,
        3,
        getPaint(
          transition.entry.foot,
          transition.entry.abbreviation,
        ),
      );

      endOffset = Offset(start.dx + 20, start.dy + 20);
      canvas.drawLine(
        start,
        endOffset,
        getPaint(transition.entry.foot, transition.entry.abbreviation),
      );
    }

    return EndPoint(
      offset: endOffset,
      direction: travelDirection,
    );
  }

  Paint getPaint(String foot, String edge) {
    if (foot == 'L') {
      return edge[0] == 'F' ? _leftPaint : _leftBackPaint;
    } else {
      return edge[0] == 'F' ? _rightPaint : _rightBackPaint;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
