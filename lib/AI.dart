import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter_gpt_tokenizer/flutter_gpt_tokenizer.dart';

class AI {
  Interpreter? _interpreter;

  AI() {
    _loadModel().catchError((error) {
      print("Failed to load the model: $error");
    });
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('model.tflite');
    } catch (e) {
      print("Error while creating the interpreter: $e");
    }
  }

  Future<String> GetAIResponse(String input) async {
    if (_interpreter == null) {
      throw Exception("Model not loaded");
    }

    // Prepare the input
    // This is a simplified version. Depending on your model, you might need
    // to tokenize the input, pad it, etc.
    final input = await Tokenizer().encode("Hello, I am Bob", modelName: "gpt-2");

    var output;

    // Run model inference
    _interpreter!.run(input, output);

    final decode = Tokenizer().decode(output, modelName: "gpt-2");

    // Process the output
    // This is a simplified version.

    return decode;
  }
}
