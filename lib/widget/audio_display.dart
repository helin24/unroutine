import 'dart:math';

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
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        _position = duration.inMilliseconds;
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (_duration > 0) {
        return;
      }
      setState(() {
        _duration = duration.inMilliseconds;
      });
    });
    _setUpSpeech();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayerState _audioState = AudioPlayerState.STOPPED;
  final SpeechToText _speech = SpeechToText();
  int _errorCount = 0;
  final SequenceModel sequence;
  bool _speechAvailable = false;
  double _playbackRate = 1.0;
  int _position = 0;
  int _duration = 0;

  Future<void> _setUpSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: _statusListener,
      onError: _errorListener,
    );
  }

  void _startListener() {
    if (_speechAvailable) {
      _speech.listen(onResult: _resultListener);
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _resultListener(SpeechRecognitionResult result) {
    if (result.alternates
        .map((e) => e.recognizedWords)
        .join(' ')
        .contains('play')) {
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
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: LinearProgressIndicator(
            value: _duration > 0 ? _position / _duration : 0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.fast_rewind),
              onPressed: _rewind,
            ),
            _audioState == AudioPlayerState.PLAYING
                ? IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: _pause,
                  )
                : IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: _play,
                  ),
            IconButton(
              icon: Icon(Icons.fast_forward),
              onPressed: _fastForward,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.directions_walk),
              onPressed: _slowDown,
            ),
            IconButton(
              icon: Icon(Icons.directions_run),
              onPressed: _speedUp,
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }

  Future<void> _play() async {
    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      await _audioPlayer.resume();
    } else if (sequence.audioUrl != null) {
      await _audioPlayer.setUrl(sequence.audioUrl);
      await _audioPlayer.resume();
    }
    _setAudioState();
    // TODO: Add error condition
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    _setAudioState();
    // TODO: Add error condition
  }

  Future<void> _rewind() async {
    // This works while paused and playing
    await _audioPlayer.getCurrentPosition().then((int position) async {
      await _audioPlayer.seek(Duration(milliseconds: position - 2000));
    });
  }

  Future<void> _fastForward() async {
    await _audioPlayer.getCurrentPosition().then((int position) async {
      await _audioPlayer.seek(Duration(milliseconds: position + 2000));
    });
  }

  Future<void> _slowDown() async {
    double newRate = max(0.25, _playbackRate - 0.25);
    await _audioPlayer.setPlaybackRate(playbackRate: newRate);
    setState(() {
      _playbackRate = newRate;
    });
  }

  Future<void> _speedUp() async {
    double newRate = min(2, _playbackRate + 0.25);
    await _audioPlayer.setPlaybackRate(playbackRate: newRate);
    setState(() {
      _playbackRate = newRate;
    });
  }

  void _setAudioState() {
    setState(() {
      _audioState = _audioPlayer.state;
    });
  }
}
