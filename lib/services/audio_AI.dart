import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'audio_AI_helper.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:audio_to_float_array/audio_to_float_array.dart';

class AudioClassification {
  static const _sampleRate = 16000; // 16kHz
  static const _expectAudioLength = 975; // milliseconds
  final int _requiredInputBuffer = (16000 * (_expectAudioLength / 1000)).toInt();
  final _recorder = FlutterSoundRecorder();
  late AudioClassificationHelper _helper;
  List<MapEntry<String, double>> _classification = List.empty();
  var _showError = false;
  late String path;

  Future<void> initializeRecorder() async {
    _helper = AudioClassificationHelper();
    await _helper.initHelper();
    path = await _setThePath();
    await _recorder.openRecorder();
  }

  Future<String> _setThePath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String tmpPath = '${appDocDir.path}/audio_classification_record.wav';
    log(tmpPath);
    return tmpPath;
  }

  Future<void> startRecording() async {
    if (_recorder.isStopped && path.isNotEmpty) {
      await _recorder.startRecorder(toFile: path, codec: Codec.pcm16WAV, sampleRate: 16000);
    }
  }

  Future<Map<String, double>> stopRecording() async {
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
    }
    return _runInference();
  }

  Future<Map<String, double>> _runInference() async {
    Float32List inputArray = await AudioToFloatArray.instance.convertAudioFile(path);
    return await _helper.inference(inputArray.sublist(0, _requiredInputBuffer));
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
    _helper.closeInterpreter();
  }
}