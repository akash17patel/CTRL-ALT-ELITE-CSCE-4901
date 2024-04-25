import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AudioClassificationHelper {
  static const _modelPath = 'assets/YAMnetModel.tflite';
  static const _labelsPath = 'assets/audioLabels.txt';

  late Interpreter _interpreter;
  late final List<String> _labels;
  late Tensor _inputTensor;
  late Tensor _outputTensor;

  Future<void> _loadModel() async {
    final options = InterpreterOptions();
    // Load model from assets
    _interpreter = await Interpreter.fromAsset(_modelPath, options: options);

    _inputTensor = _interpreter.getInputTensors().first;
    log(_inputTensor.shape.toString());
    _outputTensor = _interpreter.getOutputTensors().first;
    log(_outputTensor.shape.toString());
    log('Interpreter loaded successfully');
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(_labelsPath);
    _labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    await _loadLabels();
    await _loadModel();
  }

  Future<Map<String, double>> inference(Float32List input) async {
    final output = [List<double>.filled(521, 0.0)];
    _interpreter.run(List.of(input), output);
    var classification = <String, double>{};
    for (var i = 0; i < output[0].length; i++) {
      // Set label: points
      classification[_labels[i]] = output[0][i];
    }
    return classification;
  }

  closeInterpreter() {
    _interpreter.close();
  }
}