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
  Offset start;
  double travelDirection;
  final double directionOffset = 0;
  final Function getPaint;
  double ratio = 1;
  double height;
  double width;
  double spacer;

  double _getHeight() {
    return height == null ? null : height * ratio;
  }

  double _getWidth() {
    return width == null ? null : width * ratio;
  }

  double _getSpacer() {
    return spacer == null ? null : spacer * ratio;
  }

  EndPoint endPoint();

  void _draw();

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
    _draw();
    canvas.restore();
  }

  _debugDrawAngle(Canvas canvas, Offset start) {
    canvas.drawLine(
      start,
      Offset(start.dx, start.dy + 20),
      getDebugPaint(),
    );
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
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx,
        start.dy + 1 / 2 * _getHeight(),
      ),
      width: _getWidth(),
      height: _getHeight(),
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
        start.dx - _getHeight() * sin(travelDirection),
        start.dy + _getHeight() * cos(travelDirection),
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
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx,
        start.dy + _getHeight() / 2 + _getSpacer(),
      ),
      width: _getWidth(),
      height: _getHeight(),
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
    final changeY = _getSpacer() / 2 + _getHeight() / 2;
    final changeX = _getWidth() / 2;
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
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx - _getWidth() / 2 + _getSpacer(),
        start.dy,
      ),
      width: _getWidth(),
      height: _getHeight(),
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
    final changeY = _getHeight() / 2;
    final changeX = -_getWidth() / 2 + _getSpacer();
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

class VisualPowerPull extends VisualTransition {
  VisualPowerPull({
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

  @override
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx - 1 / 2 * _getWidth(),
        start.dy,
      ),
      width: _getWidth(),
      height: _getHeight(),
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
  endPoint() {
    final changeY = _getHeight() / 2;
    final changeX = _getWidth() / 2;
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
}

class VisualThreeTurn extends VisualTransition {
  VisualThreeTurn({
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

  @override
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx - 1 / 2 * _getWidth(),
        start.dy,
      ),
      width: _getWidth(),
      height: _getHeight(),
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
    final changeY = _getHeight() / 2;
    final changeX = _getWidth() / 2;
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
}

class VisualLoop extends VisualTransition {
  VisualLoop({
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
  final double directionOffset = pi / 2 - 0.4;
  final double width = 100;
  final double height = 100;
  final double spacer = 30;

  @override
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx - 1 / 2 * _getWidth(),
        start.dy + _getSpacer(),
      ),
      width: _getWidth(),
      height: _getHeight(),
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
  endPoint() {
    final changeY = _getHeight() / 2 + _getSpacer();
    final changeX = _getWidth() / 2;
    return EndPoint(
      offset: Offset(
        start.dx -
            changeY * sin(travelDirection + directionOffset) -
            changeX * cos(travelDirection + directionOffset),
        start.dy +
            changeY * cos(travelDirection + directionOffset) -
            changeX * sin(travelDirection + directionOffset),
      ),
      direction: travelDirection + directionOffset + pi / 2,
    );
  }
}

class VisualBunnyHop extends VisualLoop {
  VisualBunnyHop({
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

  final int markLength = 5;

  @override
  void _draw() {
    super._draw();
    _drawX();
  }

  void _drawX() {
    canvas.drawLine(
      Offset(start.dx - markLength, start.dy + _getSpacer() / 2),
      Offset(start.dx + markLength, start.dy + _getSpacer() / 2),
      getPaint(transition.entry.foot == 'L' ? 'R' : 'L', 'FO'),
    );
    canvas.drawLine(
      Offset(start.dx, start.dy + _getSpacer() / 2 - markLength),
      Offset(start.dx, start.dy + _getSpacer() / 2 + markLength),
      getPaint(transition.entry.foot == 'L' ? 'R' : 'L', 'FO'),
    );
  }
}

class VisualCrossRoll extends VisualTransition {
  VisualCrossRoll({
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
  final double spacer = 6;

  @override
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx - 1 / 2 * _getWidth() + _getSpacer(),
        start.dy,
      ),
      width: _getWidth(),
      height: _getHeight(),
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
    final changeY = _getHeight() / 2;
    final changeX = _getWidth() / 2 - _getSpacer() / 2;
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
}

class VisualStepBehind extends VisualTransition {
  VisualStepBehind({
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

  final double directionOffset = -0.3;
  final double width = 100;
  final double height = 100;
  final double spacer = 4;

  @override
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx - 1 / 2 * _getWidth() + _getSpacer(),
        start.dy - _getSpacer(),
      ),
      width: _getWidth(),
      height: _getHeight(),
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
    final changeY = _getHeight() / 2 - _getSpacer();
    final changeX = _getWidth() / 2 - _getSpacer();
    return EndPoint(
      offset: Offset(
        start.dx -
            changeY * sin(travelDirection + directionOffset) -
            changeX * cos(travelDirection + directionOffset),
        start.dy +
            changeY * cos(travelDirection + directionOffset) -
            changeX * sin(travelDirection + directionOffset),
      ),
      direction: travelDirection + directionOffset + pi / 2,
    );
  }
}

class VisualMohawk extends VisualTransition {
  VisualMohawk({
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

  final double directionOffset = -pi / 2;
  final double width = 100;
  final double height = 100;
  final double spacer = 12;

  @override
  void _draw() {
    Rect rect = Rect.fromCenter(
      center: Offset(
        start.dx - 1 / 2 * _getWidth() + _getSpacer(),
        start.dy - _getSpacer(),
      ),
      width: _getWidth(),
      height: _getHeight(),
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
    final changeY = _getHeight() / 2 - _getSpacer();
    final changeX = _getWidth() / 2 - _getSpacer();
    return EndPoint(
      offset: Offset(
        start.dx -
            changeY * sin(travelDirection + directionOffset) -
            changeX * cos(travelDirection + directionOffset),
        start.dy +
            changeY * cos(travelDirection + directionOffset) -
            changeX * sin(travelDirection + directionOffset),
      ),
      direction: travelDirection + directionOffset + pi / 2,
    );
  }
}

class VisualDefault extends VisualTransition {
  VisualDefault({
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

  final double height = 20;

  @override
  void _draw() {
    canvas.drawCircle(
      start,
      3,
      getPaint(
        transition.entry.foot,
        transition.entry.abbreviation,
      ),
    );
    Offset endOffset = Offset(start.dx, start.dy + _getHeight());
    canvas.drawLine(
      start,
      endOffset,
      getPaint(transition.entry.foot, transition.entry.abbreviation),
    );
  }

  @override
  EndPoint endPoint() {
    return EndPoint(
      offset: Offset(
        start.dx - _getHeight() * sin(travelDirection),
        start.dy + _getHeight() * cos(travelDirection),
      ),
      direction: travelDirection,
    );
  }
}
