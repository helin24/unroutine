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

abstract class VisualTransition {
  VisualTransition({
    this.canvas,
    this.transition,
    this.start,
    this.travelDirection,
    this.getPaint,
    this.ratio,
  });

  final Canvas canvas;
  final Transition transition;
  final Offset start;
  final double travelDirection;
  final double directionOffset = 0;
  final Function getPaint;
  final double ratio;

  EndPoint endPoint();

  void draw();

// This is how much to move a point on the new canvas.
  Offset _calculateOffsetWithDirection() {
    double hypotenuse = sqrt(pow(start.dx, 2) + pow(start.dy, 2));
    double initialAngle = atan(start.dx / start.dy);
    double finalAngle = initialAngle + travelDirection + directionOffset;
    double endX = sin(finalAngle) * hypotenuse;
    double endY = cos(finalAngle) * hypotenuse;
//  print('${start.dx} -> ${endX}');
//  print('${start.dy} -> ${endY}');
    return Offset(endX, endY);
  }

  void shiftAndDraw() {
    canvas.save();
    Offset rotatedOffset = _calculateOffsetWithDirection();
    canvas.rotate(travelDirection + directionOffset);
    canvas.translate(rotatedOffset.dx - start.dx, rotatedOffset.dy - start.dy);
    draw();
    canvas.restore();
  }
}

class VisualSpiral extends VisualTransition {
  final double height = 200;
  final double width = 100;

  VisualSpiral({
    canvas,
    transition,
    start,
    travelDirection,
    getPaint,
    ratio,
  }) : super(
          canvas: canvas,
          transition: transition,
          start: start,
          travelDirection: travelDirection,
          getPaint: getPaint,
          ratio: ratio,
        );

  @override
  void draw() {
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
  }

  @override
  EndPoint endPoint() {
    return EndPoint(
      offset: Offset(
        start.dx - height * sin(travelDirection),
        start.dy + height * cos(travelDirection),
      ),
      direction: travelDirection - pi / 2 + .1,
    );
  }
}

Paint getDebugPaint() {
  Paint debugPaint = Paint();
  debugPaint.color = Colors.black;
  debugPaint.strokeWidth = 1;
  return debugPaint;
}

class VisualStep extends VisualTransition {
  VisualStep({
    canvas,
    transition,
    start,
    travelDirection,
    getPaint,
    ratio,
  }) : super(
    canvas: canvas,
    transition: transition,
    start: start,
    travelDirection: travelDirection,
    getPaint: getPaint,
    ratio: ratio,
  );

  final double width = 100;
  final double height = 100;
  final double spacer = 20;

  @override
  void draw() {
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
  }

  @override
  EndPoint endPoint() {
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
}

class VisualContinueStep extends VisualTransition {
  VisualContinueStep({
    canvas,
    transition,
    start,
    travelDirection,
    getPaint,
    ratio,
  }) : super(
    canvas: canvas,
    transition: transition,
    start: start,
    travelDirection: travelDirection,
    getPaint: getPaint,
    ratio: ratio,
  );

  final double width = 100;
  final double height = 100;
  final double spacer = 5;
  @override
  final double directionOffset = -0.4;

  @override
  void draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx - width / 2 + spacer,
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
  }

  @override
  EndPoint endPoint() {
    final changeY = height / 2;
    final changeX = -width / 2 + spacer;
    return EndPoint(
      offset: Offset(
        start.dx +
            changeX * sin(travelDirection + directionOffset) -
            changeY * cos(travelDirection + directionOffset),
        start.dy +
            changeY * cos(travelDirection + directionOffset) +
            changeX * sin(travelDirection + directionOffset),
      ),
      direction: travelDirection + directionOffset,
    );
  }
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
