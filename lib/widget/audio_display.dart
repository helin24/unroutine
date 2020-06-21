import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';

class AudioDisplay extends StatelessWidget {
  AudioDisplay({this.sequence, this.saved});

  final SequenceModel sequence;
  final bool saved;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: _play,
        ),
      ],
    );
  }

  Future<void> _play() async {
    await audioPlayer.play('https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand3.wav');
  }

}
