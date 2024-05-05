import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'audio_to_float_array_platform_interface.dart';

/// An implementation of [AudioToFloatArrayPlatform] that uses method channels.
class MethodChannelAudioToFloatArray extends AudioToFloatArrayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('audio_to_float_array');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Float32List> convertAudioFile(String filePath) async {
    final List<double>? result = await methodChannel.invokeListMethod<double>('convertAudioFile', {'filePath': filePath});
    return Float32List.fromList(result ?? []);
  }
}
