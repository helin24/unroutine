import 'package:flutter/cupertino.dart';
import 'package:unroutine/model/sequence_model.dart';

class CameraDisplay extends StatefulWidget {
  CameraDisplay({this.sequence});

  final SequenceModel sequence;

  @override
  _CameraDisplayState createState() => _CameraDisplayState();
}

class _CameraDisplayState extends State<CameraDisplay> {
  @override
  Widget build(BuildContext context) {
    return Text('hello');
  }
}