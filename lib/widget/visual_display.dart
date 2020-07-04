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
            Text(
              'Example sequence',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
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
  }

  final BuildContext context;
  final SequenceModel sequence;
  Paint _leftPaint;
  Paint _leftBackPaint;
  Paint _rightPaint;
  Paint _rightBackPaint;

  @override
  void paint(Canvas canvas, Size size) {
    double currentX = 60;
    double currentY = 60;

    // Starting position
    final firstTransition = sequence.transitions.first;
    canvas.drawCircle(
        Offset(currentX, currentY),
        5,
        getPaint(
            firstTransition.entry.foot, firstTransition.entry.abbreviation));

    for (var transition in sequence.transitions) {
      Offset startOffset = Offset(currentX, currentY);
      currentX += 20;
      currentY += 20;
      Offset endOffset = Offset(currentX, currentY);

      canvas.drawLine(startOffset, endOffset,
          getPaint(transition.entry.foot, transition.entry.abbreviation));
    }
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
