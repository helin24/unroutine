import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
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
//  print('${start.dx} -> ${endX}');
//  print('${start.dy} -> ${endY}');
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
    direction: travelDirection - pi / 2 + .1,
  );
}

Paint getDebugPaint() {
  Paint debugPaint = Paint();
  debugPaint.color = Colors.black;
  debugPaint.strokeWidth = 1;
  return debugPaint;
}

EndPoint drawStep(Canvas canvas, Transition transition, Offset start,
    double travelDirection, Paint Function(String foot, String abbreviation) getPaint) {
  canvas.save();
  Offset rotatedOffset = calculateOffsetWithDirection(start, travelDirection);

  canvas.rotate(travelDirection);
  canvas.translate(rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);
  double width = 200;
  double height = 200;
  double spacer = 20;

  Rect rect = Rect.fromCenter(
    center: Offset(
      start.dx,
      start.dy + 1 / 2 * height + spacer,
    ),
    width: width,
    height: height,
  );
  canvas.drawArc(
    rect,
    pi,
    pi / 2,
    false,
    getPaint(transition.exit.foot, transition.exit.abbreviation),
  );
  canvas.restore();
  // TODO: A lot of math
  final changeY = spacer + height / 2;
  Offset result = calculateOffsetWithDirection(
    Offset(start.dx + width / 2, start.dy + changeY),
    travelDirection,
  );
  return EndPoint(
    offset: Offset(
      rotatedOffset.dx + (start.dx - result.dx),
      rotatedOffset.dy +
          changeY * cos(travelDirection) - width / 2 * sin(travelDirection) +
          (start.dy + changeY * cos(travelDirection) - width / 2 * sin(travelDirection) - result.dy),
    ),
    direction: travelDirection,
  );
}
