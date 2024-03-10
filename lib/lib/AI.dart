import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sp_ai_simple_bpe_tokenizer/sp_ai_simple_bpe_tokenizer.dart';
import 'package:sp_ai_simple_bpe_tokenizer/sp_ai_simple_bpe_tokenizer_init.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AI {
  late Interpreter _interpreter;
  bool _isInitialized = false;
  List<String> vocab = [];

  Future<void> initModel() async {
    try {
      //_interpreter = await Interpreter.fromAssetWithOps('assets/model.tflite');
      // Use SPAi bpe  to token the input
      // Make sure to have the correct vocab file in package assets
      SPAiSimpleBpeTokenizerInitializer.initialiseDI();
      final options = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/model.tflite', options: options);
      // Read the vocab
      vocab = await loadVocabularyFromAssets('assets/vocab.json');
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      throw Exception('Error loading model: $e');
    }
  }

  Future<String> GetAIResponse(String input) async {
    if (!_isInitialized) {
      throw Exception('Model not initialized');
    }

    try {
      final tokenizedText = await SPAiSimpleBpeTokenizer().encodeString(input);
      print('Tokenized Text: ${tokenizedText.tokens}');

      if (tokenizedText.tokens == null) {
        print('Tokens return null from SPAi');
        return "Sorry, I do not understand that";
      }

      List<int> processedInput = padOrTruncate(tokenizedText.tokens!, 64);
      print('Processed Input: $processedInput');

      List<List<int>> batchedInput = [processedInput];
      print(batchedInput);

      // Debug input
      List<List<int>> debugInput = List.generate(1, (_) => List.filled(64, 0));

      // Debug output
      List<List<List<double>>> outputTensor = createPrimaryOutputTensor();

      //_interpreter.run(debugInput, outputTensor);
      run(batchedInput, outputTensor);
      print('Model run completed.');

      //print('Output: $outputTensor[0]');

      // Decode the tensor
      String AIResponse = decodeGPT2OutputTopK(outputTensor[0], vocab, 50256, 8, 40);
      print(AIResponse);
      return AIResponse;
    } catch (e) {
      print('Error in GetAIResponse: $e');
      return "Sorry, an error occurred";
    }
  }

  ByteBuffer _prepareInputData(String input) {
    // Create a fixed-size Uint8List of length 384
    Uint8List inputList = Uint8List(384);

    // Convert input string to bytes
    List<int> inputBytes = utf8.encode(input);

    // Copy the encoded bytes to the Uint8List, truncating or padding as necessary
    for (int i = 0; i < inputList.length; i++) {
      if (i < inputBytes.length) {
        inputList[i] = inputBytes[i];
      }
    }

    return inputList.buffer;
  }

  String _processOutputData(Uint8List output) {
    // Assuming the output is encoded in a similar way to the input
    String outputString = utf8.decode(output);
    return outputString.trim(); // Trimming any extra padding
  }

  List<int> padOrTruncate(List<int> input, int maxLength) {
    if (input.length > maxLength) {
      return input.sublist(0, maxLength); // Truncate
    }
    while (input.length < maxLength) {
      input.add(50256); // Pad with zeros (or another appropriate padding token)
    }
    return input;
  }

  List<List<List<double>>> createPrimaryOutputTensor() {
    int dim1 = 1;
    int dim2 = 64;
    int dim3 = 50257;

    return List.generate(
      dim1,
          (_) => List.generate(
        dim2,
            (_) => List.filled(dim3, 0.0, growable: true),
      growable: true),
    growable: true);
  }

  void run(Object input, Object output) {
    // Check for null inputs
    var map = <int, Object>{};
    map[0] = output;
    runForMultipleInputs([input], map);
  }

  void runForMultipleInputs(List<Object> inputs, Map<int, Object> outputs) {
    // Check for empty outputs
    if (outputs.isEmpty) {
      throw ArgumentError('Outputs should not be null or empty.');
    }

    // Run inference
    _interpreter.runInference(inputs);

    var outputTensors = _interpreter.getOutputTensors();

    // Iterate with null-safe access
    for (var i = 0; i < outputTensors.length; i++) {
      var outputTensor = outputTensors[i];
      var outputObject = outputs[i];
      if (outputObject == null) {
        print('Null outputObject at index $i in outputs map');
      }

      if (outputObject != null) {
        outputTensor.copyTo(outputObject);
      }
    }
  }

  Future<List<String>> loadVocabularyFromAssets(String assetPath) async {
    try {
      // Load the file content as a string
      final jsonString = await rootBundle.loadString(assetPath);
      // Parse the string as JSON
      Map<String, dynamic> vocabMap = json.decode(jsonString);

      // Create a list of the same size as the number of tokens
      List<String> vocabulary = List.filled(vocabMap.length, '', growable: false);

      // Assign each token to its respective place based on its index
      vocabMap.forEach((token, index) {
        vocabulary[index] = token;
      });

      return vocabulary;
    } catch (e) {
      // Handle errors, such as file not found
      print('An error occurred while reading the vocabulary: $e');
      return [];
    }
  }


  List<List<String>> extractTokens(List<List<List<double>>> modelOutput, List<String> vocabulary) {
    List<List<String>> allTokens = [];

    for (var sequence in modelOutput) {
      List<String> sequenceTokens = [];

      for (var tokenProbabilities in sequence) {
        int maxIndex = tokenProbabilities.indexOf(tokenProbabilities.reduce(math.max));
        String token = vocabulary[maxIndex];
        sequenceTokens.add(token);
      }

      allTokens.add(sequenceTokens);
    }

    return allTokens;
  }

  String convertTokensToString(List<List<String>> tokenLists) {
    // Join each inner list of tokens into a single string (assuming each token is a word or part of a word)
    List<String> sequences = tokenLists.map((list) => list.join(" ")).toList();

    // Join all sequences. You can use "\n" to separate sequences with a newline, or " " for a space, etc.
    return sequences.join("\n");
  }

  String extractTokensAsString(List<List<double>> sequenceOutput, List<String> vocabulary, int eotTokenIndex) {
    List<String> tokens = [];
    String lastToken = '';

    for (var tokenProbabilities in sequenceOutput) {
      int maxIndex = tokenProbabilities.indexOf(tokenProbabilities.reduce(math.max));

      if (maxIndex == eotTokenIndex) {
        break;
      }

      String token = vocabulary[maxIndex];
      if (token != lastToken) {
        tokens.add(token);
        lastToken = token;
      }
    }

    return tokens.join(" ");
  }

  String decodeGPT2Output(List<List<double>> modelOutput, List<String> vocabulary, int eotTokenIndex, int maxSequenceLength) {
    List<String> tokens = [];
    var threshold = 0.2;

    for (var tokenProbabilities in modelOutput) {
      if (tokens.length >= maxSequenceLength || tokenProbabilities[eotTokenIndex] >= threshold) {
        break; // Stop if max length is reached or EOT token is encountered
      }

      int maxIndex = tokenProbabilities.indexOf(tokenProbabilities.reduce(math.max));
      tokens.add(vocabulary[maxIndex]);
    }

    return tokens.join(" ");
  }

  String decodeGPT2OutputTopK(List<List<double>> modelOutput, List<String> vocabulary, int eotTokenIndex, int maxSequenceLength, int k) {
    List<String> tokens = [];
    var random = math.Random();

    var threshold = 0.2;

    for (var tokenProbabilities in modelOutput) {
      if (tokens.length >= maxSequenceLength || tokenProbabilities[eotTokenIndex] >= threshold) {
        break; // Stop if max length is reached or EOT token is encountered
      }

      // Implementing top-k sampling
      var topKIndices = topKIndicesList(tokenProbabilities, k);
      int sampledIndex = topKIndices[random.nextInt(k)];
      tokens.add(vocabulary[sampledIndex]);
    }

    return tokens.join(" ");
  }

  List<int> topKIndicesList(List<double> probabilities, int k) {
    var indexedProbabilities = probabilities.asMap().entries.toList();
    indexedProbabilities.sort((a, b) => b.value.compareTo(a.value));
    return indexedProbabilities.take(k).map((e) => e.key).toList();
  }
  
}
