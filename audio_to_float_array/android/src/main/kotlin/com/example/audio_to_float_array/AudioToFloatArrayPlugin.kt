package com.example.audio_to_float_array

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** AudioToFloatArrayPlugin */
class AudioToFloatArrayPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "audio_to_float_array")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "convertAudioFile") {
      wavToFloatArray(call.argument<String>("filePath")!!, result)
    } else {
      result.notImplemented()
    }
  }
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun wavToFloatArray(filePath: String, result: MethodChannel.Result) {
    try {
      val file = File(filePath)
      val bytes = file.readBytes()
      val shortBuffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer()
      val shortArray = ShortArray(shortBuffer.capacity())
      shortBuffer.get(shortArray)

      val floatArray = FloatArray(shortArray.size) {
        shortArray[it] / 32768.0f // Convert to 32-bit float
      }

      result.success(floatArray.toList())
    } catch (e: Exception) {
      result.error("FILE_READING_ERROR", "Error reading audio file: ${e.localizedMessage}", null)
    }
  }
}
