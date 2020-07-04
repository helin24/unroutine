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
  SequencePainter({this.context, this.sequence});

  final BuildContext context;
  final SequenceModel sequence;

  @override
  void paint(Canvas canvas, Size size) {
    Paint leftPaint = Paint();
    leftPaint.color = Colors.green;
    leftPaint.strokeWidth = 4;

    Paint rightPaint = Paint();
    rightPaint.color = Colors.orange;
    rightPaint.strokeWidth = 4;

    double currentX = 60;
    double currentY = 60;
    for (var transition in sequence.transitions) {
      Offset startOffset = Offset(currentX, currentY);
      currentX += 20;
      currentY += 20;
      Offset endOffset = Offset(currentX, currentY);
      canvas.drawLine(startOffset, endOffset,
          transition.entry.foot == 'L' ? leftPaint : rightPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
