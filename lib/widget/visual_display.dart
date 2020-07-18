import 'dart:math';

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
    Offset offset = Offset(0, 0);
    double direction = 0;

    Iterable<VisualTransition> visualTransitions = sequence.transitions.map(
      (Transition t) => _getVisualTransition(
        canvas,
        t,
        offset,
        direction,
      ),
    );

    double minDx = 0, maxDx = 0, minDy = 0, maxDy = 0;
    for (VisualTransition vt in visualTransitions) {
      EndPoint end = vt.endPoint();
      direction = end.direction;
      offset = end.offset;

      if (offset.dx < minDx) {
        minDx = offset.dx;
      }
      if (offset.dx > maxDx) {
        maxDx = offset.dx;
      }
      if (offset.dy < minDy) {
        minDy = offset.dy;
      }
      if (offset.dy > maxDy) {
        maxDy = offset.dy;
      }
    }

    double padding = 20;
    double screenWidth = size.width - 2 * padding;
    double screenHeight = size.height - 2 * padding;

    // Resize factor for the smaller ratio
    double ratioX = screenWidth / (maxDx - minDx);
    double ratioY = screenHeight / (maxDy - minDy);
    double minRatio = min(ratioX, ratioY);

    // Shift starting point
    double offsetX = -minDx * minRatio +
        padding +
        (screenWidth - (maxDx - minDx) * minRatio) / 2;
    double offsetY = -minDy * minRatio +
        padding +
        (screenHeight - (maxDy - minDy) * minRatio) / 2;

    // TODO: Handle if width > height

    offset = Offset(offsetX, offsetY);
    direction = 0;

    // Draw starting position
    final firstTransition = sequence.transitions.first;
    canvas.drawCircle(
      offset,
      5,
      _getPaint(
        firstTransition.entry.foot,
        firstTransition.entry.abbreviation,
      ),
    );

    for (VisualTransition element in visualTransitions) {
      element.start = offset;
      element.travelDirection = direction;
      element.ratio = minRatio;
      element.shiftAndDraw();
      EndPoint result = element.endPoint();
      offset = result.offset;
      direction = result.direction;

      canvas.drawCircle(offset, 3, getDebugPaint());
    }
  }

  // Travel direction will be 0 for moving down, pi/2 for moving left, etc.
  VisualTransition _getVisualTransition(
    Canvas canvas,
    Transition transition,
    Offset start,
    double travelDirection,
  ) {
    switch (transition.move.abbreviation) {
      case 'Spiral':
        return VisualSpiral(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
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
        return VisualPowerPull(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
      case '3Turn':
        return VisualThreeTurn(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
      case 'Loop':
        return VisualLoop(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
      case 'Bunny Hop':
        return VisualBunnyHop(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
      case 'Xroll':
        return VisualCrossRoll(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
      case 'StBehind':
        return VisualStepBehind(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
      case 'Mohawk':
        return VisualMohawk(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
      case 'Xstep':
        return VisualCrossStep(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
      default:
        return VisualDefault(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: _getPaint,
          ratio: 1.0,
        );
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
