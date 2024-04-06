import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class AIClassifier {
  late Interpreter _interpreter;
  bool _isInitialized = false;
  late Map<String, int> vocab;
  late MainTokenizer tokenizer;

  // Private constructor.
  AIClassifier._privateConstructor();

  // Static private instance of the class.
  static final AIClassifier _instance = AIClassifier._privateConstructor();

  // Public getter to get the instance.
  static AIClassifier get instance => _instance;

  Future<void> initModel() async {
    try {
      final options = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/model.tflite', options: options);
      // Read the vocab
      vocab = await loadVocabularyFromAssets('assets/vocab.json');
      tokenizer = MainTokenizer(vocab, false);
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      throw Exception('Error loading model: $e');
    }
  }

  Future<String> getAIResponse(String input) async {
    if (!_isInitialized) {
      throw Exception('Model not initialized');
    }

    if (tokenizer == null) {
      throw Exception('Tokenizer not initialized');
    }

    try {
      List<int> processedInput = tokenizeAndPrepareInput(input, vocab);
      List<List<int>> batchedInput = [padOrTruncate(processedInput, 128)];

      for (int i = 0; i < batchedInput[0].length; i++) {
        print(batchedInput[0][i]);
      }

      // Prepare output tensor based on output type
      List<List<double>> outputTensor = createPrimaryOutputTensorForBERT();

      // Run the model
      run(batchedInput, outputTensor);
      print('Model run completed.');

      int response = processModelOutput(outputTensor);
      return labelToResponse(response);
      // Debug to look at the raw logits
      //return formatAllLogitsWithLabels(outputTensor);

      //return emotionFromResponseInt(response);

    } catch (e) {
      print('Error in getAIResponse: $e');
      return "Sorry, an error occurred";
    }
  }

  List<int> tokenizeAndPrepareInput(String input, Map<String, int> dic) {
    // Tokenize the input
    List<String> tokenizedText = tokenizer.tokenize(input);
    for (int i = 0; i < tokenizedText.length; i++) {
      print(tokenizedText[i]);
    }

    // Convert tokens to IDs using the dictionary
    List<int> processedInput = tokenizer.getIDFromTokens(tokenizedText);

    // Prepend [CLS] token and append [SEP] token using their IDs from the dictionary
    int clsTokenId = dic["<s>"] ?? -1;
    int sepTokenId = dic["</s>"] ?? -1;
    processedInput.insert(0, clsTokenId); // Start token
    processedInput.add(sepTokenId); // End token

    // Pad the sequence to a fixed length of 128.
    return padOrTruncate(processedInput, 128);
  }


  List<int> padOrTruncate(List<int> input, int maxLength) {
    if (input.length > maxLength) {
      return input.sublist(0, maxLength); // Truncate
    }
    while (input.length < maxLength) {
      input.add(1); // Pad with token 1
    }
    return input;
  }

  List<double> softmax(List<double> logits) {
    double maxLogit = logits.reduce(math.max);
    List<double> expLogits = logits.map((logit) => math.exp(logit - maxLogit)).toList();
    double sumExpLogits = expLogits.reduce((a, b) => a + b);
    return expLogits.map((logit) => logit / sumExpLogits).toList();
  }

  int processModelOutput(List<List<double>> outputTensor) {
    List<double> logits = outputTensor[0];
    List<double> probabilities = softmax(logits);
    int predictedClass = probabilities.indexWhere((prob) => prob == probabilities.reduce(math.max));
    print("Predicted class: $predictedClass");
    return predictedClass;
  }

  String labelToResponse(int response) {
    final math.Random random = math.Random();
    List<String> responses;

    switch (response) {
      case 0: // Anger
        responses = [
          "I sense some anger. Please tell me more about what is upsetting.",
          "It's okay to feel angry sometimes. We can keep talking about it if you like.",
          "It's okay to feel angry sometimes. Want to keep talking about it?",
          "Anger can be a strong emotion. Do you want to share more about what's causing these feelings?",
          "I'm here to listen. Can you tell me more about what made you angry?",
          "It sounds like you're really upset. Would talking about it help you feel better?",
        ];
        break;
      case 1: // Disgust
        responses = [
          "That sounds disgusting. Want to talk more about it? What exactly made you feel this way?",
          "I understand that might be upsetting. Do you want to discuss what triggered this feeling?",
          "Disgust can be a powerful emotion. Can you share more details about what provoked it?",
          "It seems something really bothered you. Would you like to delve into what happened?",
          "Feeling repelled by something can be intense. Do you feel comfortable sharing more about it?",
          "Sounds like that was really off-putting. What was it that caused such a strong reaction?",
          "Dealing with disgusting situations is tough. How did that make you feel, and why do you think it affected you so deeply?",
          "That must have been really unpleasant. Is there anything in particular that you found most repulsive?",
          "Experiencing something disgusting can leave a mark. How are you coping with these feelings?",
          "It's natural to feel disgusted by certain things. Do you often find yourself feeling this way, or was this situation unique?",
        ];
        break;
      case 2: // Fear
        responses = [
          "Fear can feel overwhelming at times. Can you share what's been scaring you lately?",
          "It's completely normal to feel afraid. Do you want to talk about what's been on your mind?",
          "Understanding our fears can help us face them. What do you think is at the root of your fear?",
          "Fear often tells us about what we deeply care about. Can you tell me more about what you're afraid of losing or facing?",
          "Sometimes talking about our fears can lessen their hold on us. Would you like to share more about yours?",
          "Facing our fears is never easy, but it's a brave step. What's one fear you'd like to conquer?",
          "Everyone has something they're afraid of. How does this particular fear affect your daily life?",
          "Fear can be a sign of something that needs attention. Is there a specific situation or thought that triggers this feeling for you?",
          "Acknowledging fear is the first step towards overcoming it. Have you found any strategies that help you deal with it?",
          "You're not alone in feeling afraid. Would sharing your fears help you feel a bit more relieved?",
        ];
        break;
      case 3: // Joy
        responses = [
          "Joy is wonderful! Tell me more about what made you happy.",
          "That's great to hear! Tell me more about what's bringing you joy.",
          "That's wonderful to hear!",
          "Joyful moments are precious. Would you like to share more about this happy experience?",
          "It sounds like you're having a great time! Can you tell me what's making you feel so joyful?",
          "Happiness is contagious. What's the secret to your good mood today?",
          "I love hearing about happy moments. Do you have any other joyful experiences you'd like to share?",
        ];
        break;
      case 4: // Neutral
        responses = [
          "Got it. Anything else you'd like to share?",
          "I'm here to listen. What else is on your mind?",
          "I see. Anything else on your mind you feel like talking about?",
          "Got it. Is there something specific you'd like to discuss further?",
          "Understood. Do any thoughts or feelings stand out to you today?",
          "Alright. Do you have any plans or ideas you're pondering over?",
          "Okay. Sometimes it's the small things. Noticed anything interesting lately?",
        ];
        break;
      case 5: // Sadness
        responses = [
          "I'm sorry to hear that. Do you want to talk about what's making you sad?",
          "Feeling sad is okay. I'm here to listen if you want to keep sharing.",
          "I'm sorry to hear you're feeling down. Want to talk more about what's been happening?",
          "It's tough going through sad times. Is there a particular event that's been on your mind?",
          "Feeling sad can be really draining. Do you want to share more about what's making you feel this way?",
          "Sadness can weigh heavily. Would discussing what's been troubling you help lighten the load?",
        ];
        break;
      case 6: // Surprise
        responses = [
          "Surprises can be shocking. What happened?",
          "Wow, that sounds unexpected. Can you share more details?",
          "That sounds unexpected! What surprised you exactly?",
          "Surprises can really throw us off. How did you react?",
          "Wow, didn't see that coming! Do you want to talk more about it?",
          "Life is full of surprises. Was this a welcome one for you?",
          "Surprise can be exciting or shocking. What are your thoughts on what happened?",
        ];
        break;
      default:
        return "Hmm, I'm not quite sure how to respond to that.";
    }

    // Select a random response from the chosen list
    int index = random.nextInt(responses.length);
    return responses[index];
  }



  List<List<double>> createPrimaryOutputTensorForBERT() {
    int dim1 = 1; // Batch size
    int dim2 = 7; // Number of classes for output

    return List.generate(dim1, (_) => List.filled(dim2, 0.0, growable: false), growable: false);
  }

  void run(Object input, Object output) {
    _interpreter.run(input, output);
  }

  Future<Map<String, int>> loadVocabularyFromAssets(String assetPath) async {
    try {
      // Load the file content as a string.
      final jsonString = await rootBundle.loadString(assetPath);
      // Parse the string as JSON into a Map.
      Map<String, dynamic> vocabMap = json.decode(jsonString);

      // Convert the dynamic map to a strongly-typed Map<String, int>.
      Map<String, int> dic = vocabMap.map<String, int>((key, value) =>
          MapEntry(key, value is int ? value : throw FormatException("Value is not an int")));

      return dic;
    } catch (e) {
      // Handle errors, such as file not found, type mismatch, or value not being an int.
      print('An error occurred while reading the vocabulary: $e');
      // Return an empty map in case of an error.
      return {};
    }
  }

  void printMap(Map<String, int> map) {
    map.forEach((key, value) {
      print('$key: $value');
    });
  }

  String formatAllLogitsWithLabels(List<List<double>> outputTensor) {
    List<double> logits = outputTensor[0];
    List<String> labels = ["anger", "disgust", "fear", "joy", "neutral", "sadness", "surprise"];

    String result = "";

    for (int i = 0; i < logits.length; i++) {
      double logit = logits[i];
      // Directly append the raw logit value.
      result += "${labels[i]}: $logit, ";
    }

    // Remove the trailing comma and space.
    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 2);
    }

    return result;
  }

  String emotionFromResponseInt(int response) {
    switch (response) {
      case 0:
        return "anger";
      case 1:
        return "disgust";
      case 2:
        return "fear";
      case 3:
        return "joy";
      case 4:
        return "neutral";
      case 5:
        return "sadness";
      case 6:
        return "surprise";
      default:
        return "Unknown Label";
    }
  }
}

// Tokenization methods originally from examples
// modifications specific to roberta
class MainTokenizer {
  late StringPrep stringPrepper;
  late SubstringFinder substringFinder;
  late Map<String, int> vocabMap;

  MainTokenizer(Map<String, int> inputVocab, bool doLowerCase) {
    vocabMap = inputVocab;
    stringPrepper = StringPrep(doLowerCase: doLowerCase);
    substringFinder = SubstringFinder(map: inputVocab);
  }

  List<String> tokenize(String text) {
    List<String> tokens = [];
    for (var token in stringPrepper.tokenize(text)) {
      tokens.addAll(substringFinder.tokenize(token));
    }
    return tokens;
  }

  List<int> getIDFromTokens(List<String> tokens) {
    List<int> outputIds = [];
    for (var token in tokens) {
      outputIds.add(vocabMap[token]!);
    }
    return outputIds;
  }
}

// Split words to substrings if needed
class SubstringFinder {
  Map<String, int> map;
  static const String unknownToken = "<unk>"; // For unknown words.
  // We dont have words over this amount
  static const int maxCharsPerWord = 200;

  SubstringFinder({required this.map});

  List<String> tokenize(String text) {
    List<String> outputTokens = [];

    // Whitespace and add special char
    List<String> tokens = StringPrep.whitespaceTokenize(text);

    for (var token in tokens) {
      if (token.length > maxCharsPerWord) {
        outputTokens.add(unknownToken);
        continue;
      }

      bool isBad = false;
      int start = 0;
      List<String> subTokens = [];

      while (start < token.length) {
        String current = "";
        int end = token.length; // Get the long one, then get small if no long

        while (start < end) {
          String subStr = token.substring(start, end);
          if (map.containsKey(subStr)) {
            current = subStr;
            break;
          }
          end--;
        }

        // Soon to be uknown token
        if (current.isEmpty) {
          isBad = true;
          break;
        }

        subTokens.add(current);
        start = end; // Move to the next substring.
      }

      if (isBad) {
        // If token can't be broken down its unknown
        outputTokens.add(unknownToken);
      } else {
        // Else add all sub tokens
        outputTokens.addAll(subTokens);
      }
    }

    return outputTokens;
  }
}

// Handles cleaning the input and prepping it
class StringPrep {
  bool doLowerCase;

  StringPrep({required this.doLowerCase});

  List<String> tokenize(String text) {
    String cleanedText = cleanText(text);

    List<String> originals = whitespaceTokenize(cleanedText);
    StringBuffer sb = StringBuffer();
    for (var token in originals) {
      if (doLowerCase) {
        token = token.toLowerCase();
      }
      List<String> list = handlePunc(token);
      for (var subToken in list) {
        sb.write("$subToken ");
      }
    }
    return whitespaceTokenize(sb.toString());
  }

  // Performs invalid character removal and whitespace cleanup on text.
  static String cleanText(String text) {
    StringBuffer sb = StringBuffer("");
    for (int index = 0; index < text.length; index++) {
      String ch = text[index];
      if (CharChecker.isInvalid(ch) || CharChecker.isControl(ch)) {
        continue;
      }
      if (CharChecker.isWhitespace(ch)) {
        sb.write("Ġ");
      } else {
        sb.write(ch);
      }
    }
    return sb.toString();
  }

  /*
  static List<String> whitespaceTokenize(String text) {
    // Split the text initially.
    List<String> parts = text.split("Ġ");

    // Reattach the 'Ġ' character to each part except the first one.
    List<String> tokens = [];
    for (int i = 0; i < parts.length; i++) {
      if (i == 0) {
        // First token, add as is.
        tokens.add(parts[i]);
      } else {
        // For subsequent tokens, reattach 'Ġ'.
        tokens.add("Ġ" + parts[i]);
      }
    }

    return tokens;
  }

  */
  static List<String> whitespaceTokenize(String text) {
    return text.trim().split(" ");
  }

  // Splits punctuation
  static List<String> handlePunc(String text) {
    List<String> tokens = [];
    bool startNewWord = true;
    for (int i = 0; i < text.length; i++) {
      String ch = text[i];
      if (CharChecker.isPunctuation(ch)) {
        tokens.add(ch);
        startNewWord = true;
      } else {
        if (startNewWord) {
          tokens.add("");
          startNewWord = false;
        }
        tokens[tokens.length - 1] = tokens[tokens.length - 1] + ch;
      }
    }
    return tokens;
  }
}

// To check whether a char is whitespace/control/punctuation.
class CharChecker {
  // Whitespace or control type
  static bool isWhitespace(String ch) {
    final type = ch.codeUnitAt(0);
    return type == 32 || type == 9 || type == 10 || type == 13;
  }

  // To determine whether it's an empty or unknown character.
  static bool isInvalid(String ch) {
    return (ch == String.fromCharCode(0) || ch == String.fromCharCode(0xFFFD));
  }

  // To determine whether it's a control character(exclude whitespace, "\n", "\t", "\r").
  static bool isControl(String ch) {
    if (isWhitespace(ch)) {
      // whitespace
      return false;
    }

    final type = ch.codeUnitAt(0);
    return (type == 127 ||
        (type >= 1 && type <= 31) ||
        (type >= 128 && type <= 159));
  }

  // To judge whether it's a punctuation
  static bool isPunctuation(String ch) {
    final type = ch.codeUnitAt(0);
    return (type >= 33 && type <= 47) || // ASCII Punctuation & Symbols
        (type >= 58 && type <= 64) ||
        (type >= 91 && type <= 96) ||
        (type >= 123 && type <= 126) ||
        (type >= 160 && type <= 191);
  }
}
