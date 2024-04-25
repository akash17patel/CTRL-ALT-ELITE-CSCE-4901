import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:typed_data';
import 'audio_to_float_array_method_channel.dart';

abstract class AudioToFloatArrayPlatform extends PlatformInterface {
  /// Constructs a AudioToFloatArrayPlatform.
  AudioToFloatArrayPlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioToFloatArrayPlatform _instance = MethodChannelAudioToFloatArray();

  /// The default instance of [AudioToFloatArrayPlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioToFloatArray].
  static AudioToFloatArrayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AudioToFloatArrayPlatform] when
  /// they register themselves.
  static set instance(AudioToFloatArrayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Float32List> convertAudioFile(String filePath) {
    throw UnimplementedError('convertAudioFile() has not been implemented.');
  }
}