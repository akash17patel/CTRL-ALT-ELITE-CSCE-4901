package com.example.mind_lift

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder
class MainActivity: FlutterActivity() {

    // Turn audio into a float array for android
    private val CHANNEL = "CrisisDetection"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "wavToFloatArray") {
                val filePath = call.argument<String>("filePath") ?: return@setMethodCallHandler
                wavToFloatArray(filePath, result)
            } else {
                result.notImplemented()
            }
        }
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