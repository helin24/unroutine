import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';

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

    // TODO: Need a better way to distinguish backward vs. forward
    _leftBackPaint = Paint();
    _leftBackPaint.color = Colors.green;
    _leftBackPaint.strokeWidth = 3;

    _rightPaint = Paint();
    _rightPaint.color = Colors.orange;
    _rightPaint.strokeWidth = 4;

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
    Offset current = Offset(60, 80);

    // Starting position
    final firstTransition = sequence.transitions.first;
    canvas.drawCircle(
      current,
      5,
      getPaint(
        firstTransition.entry.foot,
        firstTransition.entry.abbreviation,
      ),
    );

    for (var transition in sequence.transitions) {
      current = drawTransition(canvas, transition, current, -0.1);
    }
  }

  Offset calculateOffsetWithDirection(Offset start, double direction) {
    double hypotenuse = sqrt(pow(start.dx, 2) + pow(start.dy, 2));
    double initialAngle = atan(start.dx / start.dy);
    double finalAngle = initialAngle + direction;
    double endX = sin(finalAngle) * hypotenuse;
    double endY = cos(finalAngle) * hypotenuse;
    return Offset(endX, endY);
  }

  // Travel direction will be 0 for moving to the right, pi/2 for moving down, etc.
  Offset drawTransition(Canvas canvas, Transition transition, Offset start,
      double travelDirection) {
    Offset endOffset;
    if (transition.move.abbreviation == 'Spiral') {
      canvas.save();
      Offset rotatedOffset =
          calculateOffsetWithDirection(start, travelDirection);

      canvas.rotate(travelDirection);
      canvas.translate(
          rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);
      double width = 100;
      double height = 200;
      Rect rect = Rect.fromCenter(
        center: Offset(
          start.dx,
          start.dy + 1 / 2 * height,
        ),
        width: width,
        height: height,
      );
      canvas.drawArc(
        rect,
        pi / 2,
        pi,
        false,
        getPaint(transition.entry.foot, transition.entry.abbreviation),
      );
      canvas.restore();
      Offset result = calculateOffsetWithDirection(
        Offset(start.dx, start.dy + height),
        travelDirection,
      );

      return Offset(
        rotatedOffset.dx + (start.dx - result.dx),
        rotatedOffset.dy +
            height * cos(travelDirection) +
            (start.dy + height * cos(travelDirection) - result.dy),
      );
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

    return endOffset;
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
