import 'dart:math';
import 'dart:ui';

import 'package:unroutine/model/sequence_model.dart';

class EndPoint {
  EndPoint({this.offset, this.direction});

  final Offset offset;
  final double direction;
}

Offset calculateOffsetWithDirection(Offset start, double direction) {
  double hypotenuse = sqrt(pow(start.dx, 2) + pow(start.dy, 2));
  double initialAngle = atan(start.dx / start.dy);
  double finalAngle = initialAngle + direction;
  double endX = sin(finalAngle) * hypotenuse;
  double endY = cos(finalAngle) * hypotenuse;
  return Offset(endX, endY);
}

EndPoint drawSpiral(Canvas canvas, Transition transition, Offset start,
    double travelDirection, Function getPaint) {
  canvas.save();
  Offset rotatedOffset = calculateOffsetWithDirection(start, travelDirection);

  canvas.rotate(travelDirection);
  canvas.translate(rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);
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
  return EndPoint(
    offset: Offset(
      rotatedOffset.dx + (start.dx - result.dx),
      rotatedOffset.dy +
          height * cos(travelDirection) +
          (start.dy + height * cos(travelDirection) - result.dy),
    ),
    direction: travelDirection,
  );
}
