import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:flutter/material.dart';

class AudioDisplay extends StatefulWidget {
  AudioDisplay({this.sequence, this.saved});

  final SequenceModel sequence;
  final bool saved;

  @override
  _AudioDisplayState createState() => _AudioDisplayState();
}

class _AudioDisplayState extends State<AudioDisplay> {
  @override
  void initState() {
    super.initState();
    _setUpSpeech();
  }

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _setUpSpeech() async {
    SpeechToText speech = SpeechToText();
    bool available = await speech.initialize( onStatus: _statusListener, onError: _errorListener );
    if ( available ) {
      print('this worked');
      speech.listen( onResult: _resultListener );
    }
    else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _resultListener(SpeechRecognitionResult result) {
    print('resultListener ' + result.alternates.map((e) => e.recognizedWords).join(' '));
  }

  void _errorListener(SpeechRecognitionError error) {
    print('errorListener ' + error.toString());
  }

  void _statusListener(String input) {
    print('statusListener: ' + input);
  }

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
