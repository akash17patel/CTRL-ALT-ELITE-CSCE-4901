// credit to flutter_tflite examples

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'audio_AI_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioClassificationScreen extends StatefulWidget {
  final String title;
  const AudioClassificationScreen({Key? key, required this.title}) : super(key: key);

  @override
  _AudioClassificationScreenState createState() => _AudioClassificationScreenState();
}

class _AudioClassificationScreenState extends State<AudioClassificationScreen> {
  static const _sampleRate = 16000; // 16kHz
  static const _expectAudioLength = 975; // milliseconds
  final int _requiredInputBuffer = (16000 * (_expectAudioLength / 1000)).toInt();
  final _recorder = FlutterSoundRecorder();
  late AudioClassificationHelper _helper;
  List<MapEntry<String, double>> _classification = List.empty();
  bool _isRecording = false;
  var _showError = false;

  // Member variables to hold classification results and recording state
  String _classificationResult = 'Press the button to start recording...';

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    _helper = AudioClassificationHelper();
    await _helper.initHelper();
    bool success = await _requestPermission();
    if (!success) {
      setState(() {
        _showError = true;
      });
    }
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  Future<void> _startRecording() async {
    final permissionGranted = await _requestPermission();
    if (!permissionGranted) {
      return;
    }

    await _recorder.openRecorder();
    await _recorder.startRecorder(
      toFile: 'audio_classification_record.wav',
      codec: Codec.pcm16WAV, // Make sure is compatible
      sampleRate: 16000,
    );
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    setState(() {
      _isRecording = false;
    });

    // Call analysis / logic for analyzing the audio.
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _helper.closeInterpreter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _isRecording ? _stopRecording : _startRecording,
        tooltip: 'Record Audio',
        child: Icon(_isRecording ? Icons.stop : Icons.mic),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              _classificationResult,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(height: 20), // Provide some spacing between text and button
          FloatingActionButton(
            onPressed: () async {
              if (_isRecording) {
                await _stopRecording();
                setState(() {
                  _isRecording = false;
                  // Update the UI to indicate recording has stopped
                  // Optionally, process and display classification results here
                  _classificationResult = 'Recording stopped, processing...';
                });
                // Simulate processing and updating classification results
                await Future.delayed(Duration(seconds: 1)); // Simulate processing delay
                setState(() {
                  _classificationResult = 'Classification result: [Your Result Here]';
                });
              } else {
                await _startRecording();
                setState(() {
                  _isRecording = true;
                  // Update the UI to indicate recording has started
                  _classificationResult = 'Recording... Speak now!';
                });
              }
            },
            child: Icon(_isRecording ? Icons.stop : Icons.mic),
            backgroundColor: _isRecording ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }
}
