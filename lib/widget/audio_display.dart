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
  _AudioDisplayState({this.sequence});

  @override
  void initState() {
    super.initState();
    _setUpSpeech();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayerState _audioState = AudioPlayerState.STOPPED;
  final SpeechToText _speech = SpeechToText();
  int _errorCount = 0;
  final SequenceModel sequence;
  bool speechAvailable = false;

  Future<void> _setUpSpeech() async {
    speechAvailable = await _speech.initialize( onStatus: _statusListener, onError: _errorListener );
  }

  void _startListener() {
    if ( speechAvailable ) {
      _speech.listen(onResult: _resultListener);
    } else {
      print("The user has denied the use of speech recognition.");
    }
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
        _audioState == AudioPlayerState.PLAYING ? IconButton(
          icon:  Icon(Icons.pause),
          onPressed: _pause,
        ) : IconButton(
          icon:  Icon(Icons.play_arrow),
          onPressed: _play,
        ),
      ],
    );
  }

  Future<void> _play() async {
    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      await _audioPlayer.resume();
    } else if (sequence.audioUrl != null) {
      await _audioPlayer.play(sequence.audioUrl);
    }
    _setAudioState();
    // TODO: Add error condition
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    _setAudioState();
    // TODO: Add error condition
  }

  void _setAudioState() {
    setState(() {
      _audioState = _audioPlayer.state;
    });
  }

}
