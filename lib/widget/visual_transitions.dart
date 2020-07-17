import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:unroutine/model/sequence_model.dart';

class EndPoint {
  EndPoint({this.offset, this.direction});

  final Offset offset;
  final double direction;
}

// This is how much to move a point on the new canvas.
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

EndPoint drawSpiral(
  Canvas canvas,
  Transition transition,
  Offset start,
  double travelDirection,
  Function getPaint,
) {
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

  return EndPoint(
    offset: Offset(
      start.dx - height * sin(travelDirection),
      start.dy + height * cos(travelDirection),
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

EndPoint drawStep(
  Canvas canvas,
  Transition transition,
  Offset start,
  double travelDirection,
  Paint Function(String foot, String abbreviation) getPaint,
) {
  canvas.save();
  Offset rotatedOffset = calculateOffsetWithDirection(start, travelDirection);
  canvas.rotate(travelDirection);
  canvas.translate(rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);

  double width = 100;
  double height = 100;
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

  final changeY = spacer + height / 2;
  final changeX = width / 2;
  return EndPoint(
    offset: Offset(
      start.dx -
          changeY * sin(travelDirection) +
          changeX * cos(travelDirection),
      start.dy +
          changeY * cos(travelDirection) -
          changeX * sin(travelDirection),
    ),
    direction: travelDirection,
  );
}

EndPoint drawContinueStep(
    Canvas canvas,
    Transition transition,
    Offset start,
    double travelDirection,
    Paint Function(String foot, String abbreviation) getPaint) {
  canvas.save();

  travelDirection = travelDirection - 0.4;
  Offset rotatedOffset = calculateOffsetWithDirection(start, travelDirection);
  canvas.rotate(travelDirection);
  canvas.translate(rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);
  double width = 100;
  double height = 100;
  double spacer = 5;

  Rect rect = Rect.fromCenter(
    center: Offset(
      start.dx - width / 2 + spacer,
      start.dy,
    ),
    width: width,
    height: height,
  );
//  canvas.drawRect(rect, getDebugPaint());
  canvas.drawArc(
    rect,
    0,
    pi / 2,
    false,
    getPaint(transition.exit.foot, transition.exit.abbreviation),
  );
  canvas.restore();
  final changeY = height / 2;
  final changeX = -width / 2 + spacer;
  return EndPoint(
    offset: Offset(
      start.dx +
          changeX * sin(travelDirection) -
          changeY * cos(travelDirection),
      start.dy +
          changeY * cos(travelDirection) +
          changeX * sin(travelDirection),
    ),
    direction: travelDirection,
  );
}

EndPoint drawPowerPull(
  Canvas canvas,
  Transition transition,
  Offset start,
  double travelDirection,
  Paint Function(String foot, String abbreviation) getPaint,
) {
  canvas.save();
  Offset rotatedOffset = calculateOffsetWithDirection(start, travelDirection);
  canvas.rotate(travelDirection);
  canvas.translate(rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);

  double width = 100;
  double height = 100;

  Rect rect = Rect.fromCenter(
    center: Offset(
      start.dx - 1 / 2 * width,
      start.dy,
    ),
    width: width,
    height: height,
  );
  canvas.drawArc(
    rect,
    0,
    pi / 2,
    false,
    getPaint(transition.exit.foot, transition.exit.abbreviation),
  );
  canvas.restore();

  final changeY = height / 2;
  final changeX = width / 2;
  return EndPoint(
    offset: Offset(
      start.dx -
          changeY * sin(travelDirection) -
          changeX * cos(travelDirection),
      start.dy +
          changeY * cos(travelDirection) -
          changeX * sin(travelDirection),
    ),
    direction: travelDirection,
  );
}

EndPoint drawThreeTurn(
  Canvas canvas,
  Transition transition,
  Offset start,
  double travelDirection,
  Paint Function(String foot, String abbreviation) getPaint,
) {
  canvas.save();
  Offset rotatedOffset = calculateOffsetWithDirection(start, travelDirection);
  canvas.rotate(travelDirection);
  canvas.translate(rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);

  double width = 100;
  double height = 100;

  Rect rect = Rect.fromCenter(
    center: Offset(
      start.dx - 1 / 2 * width,
      start.dy,
    ),
    width: width,
    height: height,
  );
  canvas.drawArc(
    rect,
    0,
    pi / 2,
    false,
    getPaint(transition.exit.foot, transition.exit.abbreviation),
  );
  canvas.restore();

  final changeY = height / 2;
  final changeX = width / 2;
  return EndPoint(
    offset: Offset(
      start.dx -
          changeY * sin(travelDirection) -
          changeX * cos(travelDirection),
      start.dy +
          changeY * cos(travelDirection) -
          changeX * sin(travelDirection),
    ),
    direction: travelDirection,
  );
}

EndPoint drawLoop(
  Canvas canvas,
  Transition transition,
  Offset start,
  double travelDirection,
  Paint Function(String foot, String abbreviation) getPaint,
) {
  canvas.save();
  travelDirection = travelDirection + pi / 2 - 0.4;
  Offset rotatedOffset = calculateOffsetWithDirection(start, travelDirection);
  canvas.rotate(travelDirection);
  canvas.translate(rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);

  double width = 100;
  double height = 100;
  double spacer = 30;

  Rect rect = Rect.fromCenter(
    center: Offset(
      start.dx - 1 / 2 * width,
      start.dy + spacer,
    ),
    width: width,
    height: height,
  );
  canvas.drawArc(
    rect,
    0,
    pi / 2,
    false,
    getPaint(transition.exit.foot, transition.exit.abbreviation),
  );
  canvas.restore();

  final changeY = height / 2 + spacer;
  final changeX = width / 2;
  return EndPoint(
    offset: Offset(
      start.dx -
          changeY * sin(travelDirection) -
          changeX * cos(travelDirection),
      start.dy +
          changeY * cos(travelDirection) -
          changeX * sin(travelDirection),
    ),
    direction: travelDirection + pi / 2,
  );
}
