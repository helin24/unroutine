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
    _leftPaint.strokeWidth = 2;
    _leftPaint.style = PaintingStyle.stroke;

    // TODO: Need a better way to distinguish backward vs. forward
    _leftBackPaint = Paint();
    _leftBackPaint.color = Colors.green;
    _leftBackPaint.strokeWidth = 4;
    _leftBackPaint.style = PaintingStyle.stroke;

    _rightPaint = Paint();
    _rightPaint.color = Colors.orange;
    _rightPaint.strokeWidth = 2;
    _rightPaint.style = PaintingStyle.stroke;

    _rightBackPaint = Paint();
    _rightBackPaint.color = Colors.deepOrange;
    _rightBackPaint.strokeWidth = 4;
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
    Offset offset = Offset(100, 40);
    double direction = -0.2;

    // Starting position
    final firstTransition = sequence.transitions.first;
    canvas.drawCircle(
      offset,
      5,
      _getPaint(
        firstTransition.entry.foot,
        firstTransition.entry.abbreviation,
      ),
    );

    for (var transition in sequence.transitions) {
      VisualTransition element =
          _getVisualTransition(canvas, transition, offset, direction);
      EndPoint result;
      if (element == null) {
        result = _drawDefault(canvas, transition, offset, direction);
      } else {
        element.shiftAndDraw();
        result = element.endPoint();
      }

      offset = result.offset;
      direction = result.direction;

      canvas.drawCircle(offset, 3, getDebugPaint());
    }
  }

  EndPoint _drawDefault(
    Canvas canvas,
    Transition transition,
    Offset offset,
    double direction,
  ) {
    canvas.drawCircle(
      offset,
      3,
      _getPaint(
        transition.entry.foot,
        transition.entry.abbreviation,
      ),
    );

    Offset endOffset = Offset(offset.dx + 20, offset.dy + 20);
    canvas.drawLine(
      offset,
      endOffset,
      _getPaint(transition.entry.foot, transition.entry.abbreviation),
    );
    return EndPoint(
      offset: endOffset,
      direction: direction,
    );
  }

  // Travel direction will be 0 for moving to the right, pi/2 for moving down, etc.
  VisualTransition _getVisualTransition(
    Canvas canvas,
    Transition transition,
    Offset start,
    double travelDirection,
  ) {
    switch (transition.move.abbreviation) {
      case 'Spiral':
        {
          return VisualSpiral(
            canvas: canvas,
            transition: transition,
            start: start,
            travelDirection: travelDirection,
            getPaint: _getPaint,
            ratio: 1.0,
          );
        }
      case 'Step':
        {
          if (transition.entry.abbreviation[0] ==
                  transition.exit.abbreviation[0] &&
              transition.entry.abbreviation[1] !=
                  transition.exit.abbreviation[1]) {
            // This is where direction (backwards/forwards) doesn't change, but
            // the edge changes. Essentially it is moving on the same arc.
            return VisualContinueStep(
              canvas: canvas,
              transition: transition,
              start: start,
              travelDirection: travelDirection,
              getPaint: _getPaint,
              ratio: 1.0,
            );
          }
          return VisualStep(
            canvas: canvas,
            transition: transition,
            start: start,
            travelDirection: travelDirection,
            getPaint: _getPaint,
            ratio: 1.0,
          );
        }
      case 'PwPull':
        {
          return VisualPowerPull(
            canvas: canvas,
            transition: transition,
            start: start,
            travelDirection: travelDirection,
            getPaint: _getPaint,
            ratio: 1.0,
          );
        }
      case '3Turn':
        {
          return VisualThreeTurn(
            canvas: canvas,
            transition: transition,
            start: start,
            travelDirection: travelDirection,
            getPaint: _getPaint,
            ratio: 1.0,
          );
        }
      case 'Loop':
      // TODO: Add an 'x' to bunny hop to show toe.
      case 'Bunny Hop':
        {
          return VisualLoop(
            canvas: canvas,
            transition: transition,
            start: start,
            travelDirection: travelDirection,
            getPaint: _getPaint,
            ratio: 1.0,
          );
        }
      default:
        return null;
    }
  }

  Paint _getPaint(String foot, String edge) {
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
