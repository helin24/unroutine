import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
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
  bool _recording = false;

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

  Future<void> _record() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    print('tempPath: ' + tempPath);

    controller
        .startVideoRecording('Pictures/test')
        .then((value) => setState(() {
              _recording = true;
            }));
  }

  void _stopRecording() {
    controller.stopVideoRecording().then((value) => setState(() {
          _recording = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller)),
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: _recording ? _stopRecording : _record,
        ),
      ],
    );
  }
}
