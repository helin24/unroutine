import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:unroutine/model/sequence_model.dart';

class CameraDisplay extends StatefulWidget {
  CameraDisplay({this.sequence});

  final SequenceModel sequence;

  @override
  _CameraDisplayState createState() => _CameraDisplayState();
}

class _CameraDisplayState extends State<CameraDisplay> {
  CameraController controller;
  bool waiting = true;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    availableCameras().then((cameras) {
      if (cameras.length == 0) {
        return;
      }
      controller = CameraController(cameras.first, ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          waiting = false;
        });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (waiting) {
      return CircularProgressIndicator();
    }
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio:
        controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}