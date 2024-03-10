// credit to flutter_tflite examples

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'audio_AI_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioClassificationScreen extends StatefulWidget {
  final String title;
  const AudioClassificationScreen({super.key, required this.title});

  @override
  _AudioClassificationScreenState createState() =>
      _AudioClassificationScreenState();
}

class _AudioClassificationScreenState extends State<AudioClassificationScreen> {
  static const _sampleRate = 16000; // 16kHz
  static const _expectAudioLength = 975; // milliseconds
  final int _requiredInputBuffer =
      (16000 * (_expectAudioLength / 1000)).toInt();
  final _recorder = FlutterSoundRecorder();
  late AudioClassificationHelper _helper;
  List<MapEntry<String, double>> _classification = List.empty();
  bool _isRecording = false;
  var _showError = false;

  late String path;

  // Platform channel
  static const MethodChannel channel =
      MethodChannel('com.example.mindlift_flutter/audio_AI');

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

    path = await _setThePath();
  }

  Future<String> _setThePath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Specify the file path using the directory path.
    return appDocPath = '$appDocPath/audio_classification_record.wav';
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
      toFile: path,
      codec: Codec.pcm16WAV,
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

    _runInference();
  }

  Future<Float32List> _getAudioFloatArray() async {
    try {
      final List? result = await channel
          .invokeMethod<List<dynamic>>('wavToFloatArray', {'filePath': path});
      // Ensure there's a null check or default value since .cast<double>() could fail if result is null
      final List<double>? doubleList = result?.map((e) => e as double).toList();
      if (doubleList != null) {
        return Float32List.fromList(doubleList);
      } else {
        throw Exception('Failed to convert audio file to float array.');
      }
    } catch (e) {
      log("Failed to get audio array: '${e.toString()}'.");
      return Float32List(0); // Return an empty Float32List in case of error
    }
  }

  Future<bool> checkIfFileExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      print("File exists at: $path");
      return true;
    } else {
      print("File does not exist at: $path");
      return false;
    }
  }

  Future<void> _runInference() async {
    Float32List inputArray = await _getAudioFloatArray();
    final result =
        await _helper.inference(inputArray.sublist(0, _requiredInputBuffer));
    setState(() {
      // take the top classification
      _classification = (result.entries.toList()
            ..sort(
              (a, b) => a.value.compareTo(b.value),
            ))
          .reversed
          .take(1)
          .toList();
    });
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
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              _classificationResult,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          const SizedBox(height: 20), // Provide some spacing between text and button
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
                await Future.delayed(
                    const Duration(seconds: 1)); // Simulate processing delay
                setState(() {
                  String classifiedItem = _classification.first.key;
                  _classificationResult = 'Audio was $classifiedItem';
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
            backgroundColor: _isRecording ? Colors.red : Colors.green,
            child: Icon(_isRecording ? Icons.stop : Icons.mic),
          ),
        ],
      ),
    );
  }
}
