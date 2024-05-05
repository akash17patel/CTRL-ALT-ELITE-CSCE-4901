import 'dart:typed_data';
import 'audio_to_float_array_platform_interface.dart';

class AudioToFloatArray {
  Future<String?> getPlatformVersion() {
    return AudioToFloatArrayPlatform.instance.getPlatformVersion();
  }
  AudioToFloatArray._();

  static final AudioToFloatArray instance = AudioToFloatArray._();

  Future<Float32List> convertAudioFile(String filePath) async {
    return AudioToFloatArrayPlatform.instance.convertAudioFile(filePath);
  }
}
