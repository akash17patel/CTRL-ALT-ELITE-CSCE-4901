import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:mind_lift/main.dart';

import 'audio_AI_helper.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_to_float_array/audio_to_float_array.dart';
import 'local_notification_service.dart';

class AudioClassification {
  // Singleton
  AudioClassification._privateConstructor(); // Private constructor for the singleton
  static final AudioClassification instance =
  AudioClassification._privateConstructor();

  static const _sampleRate = 16000; // 16kHz
  static const _expectAudioLength = 975; // milliseconds
  final int _requiredInputBuffer =
  (16000 * (_expectAudioLength / 1000)).toInt();
  final _recorder = FlutterSoundRecorder();
  late AudioClassificationHelper _helper;
  List<MapEntry<String, double>> _classification = List.empty();
  Timer? _timer;
  CrisisDetection crisis = CrisisDetection();

  late String path;

  Future<void> initRecorder() async {
    _helper = AudioClassificationHelper();
    await _helper.initHelper();
    path = await _setThePath();
  }

  Future<void> start() async {
    if(path.isEmpty) await _setThePath();
    await _startRecording(); // Start the first recording before setting the timer
    _timer?.cancel(); // Cancel any existing timer

    // Initialize the timer with a slight delay before the first execution to avoid immediate overlap
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) async {
      // Stop recording and handle inference if recording was ongoing
      await _stopRecording();

      // Check if the recorder is ready before starting a new recording
      if (!_recorder.isRecording) {
        await _startRecording();
      } else {
        print("Recorder was still busy, skipped a cycle.");
        // Optionally add logic to adjust or reset the timer to maintain timing integrity
      }
    });
  }


  Future<String> _setThePath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Specify the file path using the directory path.
    return appDocPath = '$appDocPath/audio_classification_record.wav';
  }

  Future<void> _startRecording() async {
    await _recorder.openRecorder();
    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
      sampleRate: 16000,
    );
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    await _runInference();
  }

  Future<Float32List> _getAudioFloatArray() async {
    try {
      final List? result = await AudioToFloatArray.instance.convertAudioFile(
          path);
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

    if (result.isEmpty) print("Empty result");

    _classification = (result.entries.toList()
      ..sort(
            (a, b) => a.value.compareTo(b.value),
      ))
        .reversed
        .take(1)
        .toList();

    crisis.updateValues(result);
    print(crisis.labelValues);
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _helper.closeInterpreter();
  }

  Future<void> exportDataToFile(dynamic data) async {
    // Get the directory to store the file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/example_data.json');

    // Serialize your data to a JSON string
    String jsonData = jsonEncode(data);

    // Write the JSON string to the file
    await file.writeAsString(jsonData);
    print("Data exported to ${file.path}");
  }

  Future<void> turnOff() async{
    _recorder.closeRecorder();
    _helper.closeInterpreter();
    _timer?.cancel(); // Cancel any existing timer
  }

  Future<void> turnOn() async{
    await initRecorder();
    await start();
  }
}

class CrisisDetection {
  static const List<String> classificationLabels = [
    "Screaming\r",
    "Crying, sobbing\r",
    "Whimper\r",
    "Wail, moan\r",
    "Groan\r",
    "Sniff\r"
  ];

  static const double threshold = 0.08;  // Threshold to trigger a crisis event
  Map<String, List<double>> labelValues = {};

  CrisisDetection() {
    for (var label in classificationLabels) {
      labelValues[label] = [];  // Initialize with an empty list
    }
  }

  // Update values for each label and maintain only the last three entries
  void updateValues(Map<String, double> incomingValues) {
    for (var label in classificationLabels) {
      if (incomingValues.containsKey(label)) {
        var list = labelValues[label]!;
        list.add(incomingValues[label]!);  // Add new value

        // Maintain only the last three values
        if (list.length > 3) {
          list.removeAt(0);  // Remove the oldest value
        }
        labelValues[label] = list;
      }
    }
    checkCrisis();  // Check if we should trigger a crisis action
  }

  // Check if the sum of all labels' values exceeds the threshold
  void checkCrisis() {
    // Get all values and flatten them into a single iterable
    var allValues = labelValues.values.expand((i) => i);

    // Debug: Print the values to see what's being processed
    print("All values: $allValues");

    // Only proceed if there are elements to reduce
    if (allValues.isNotEmpty) {
      double sum = allValues.reduce((a, b) => a + b);
      print("Sum of values: $sum");  // Debug: Output the computed sum

      if (sum > threshold) {
        triggerCrisisAction();
      }
    } else {
      print("No values to process for crisis detection.");  // Inform that there are no values
    }
  }

  // Stub for triggering a crisis action
  void triggerCrisisAction() {
    print("Crisis detected! Taking action...");
    service.showNotification(id: 5, title: "Crisis Detected", body: "Are you alright?");
    // Clear all stored values in labelValues
    for (var label in classificationLabels) {
      labelValues[label] = [];
    }
  }
}