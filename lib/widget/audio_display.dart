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
  _AudioDisplayState createState() => _AudioDisplayState(sequence: sequence);
}

class _AudioDisplayState extends State<AudioDisplay> {
  final SequenceModel sequence;

  _AudioDisplayState({this.sequence});

  @override
  void initState() {
    super.initState();
    _setUpSpeech();
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  final SpeechToText _speech = SpeechToText();
  int _errorCount = 0;

  Future<void> _setUpSpeech() async {
    bool available = await _speech.initialize( onStatus: _statusListener, onError: _errorListener );
    if ( available ) {
      _startListener();
    }
    else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _startListener() {
    _speech.listen(onResult: _resultListener);
  }

  void _resultListener(SpeechRecognitionResult result) {
    if (result.alternates.map((e) => e.recognizedWords).join(' ').contains('play')) {
      _play();
    }
    _startListener();
  }

  void _errorListener(SpeechRecognitionError error) {
    print('errorListener ' + error.toString());
    _errorCount += 1;
    if (_errorCount < 5) {
      _startListener();
    }
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
    if (sequence.audioUrl != null) {
      await audioPlayer.play(sequence.audioUrl);
    }
    // TODO: Add error condition
  }
}
