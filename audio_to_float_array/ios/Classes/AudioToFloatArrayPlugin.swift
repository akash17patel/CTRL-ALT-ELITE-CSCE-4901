import Flutter
import UIKit
import AVFoundation

public class AudioToFloatArrayPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "audio_to_float_array", binaryMessenger: registrar.messenger())
        let instance = AudioToFloatArrayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "convertAudioFile":
            guard let args = call.arguments as? [String: Any],
                  let filePath = args["filePath"] as? String else {
                      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments received", details: nil))
                      return
            }
            wavToFloatArray(filePath: filePath, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func wavToFloatArray(filePath: String, result: @escaping FlutterResult) {
        guard let fileURL = URL(string: filePath) else {
            result(FlutterError(code: "INVALID_PATH", message: "Provided file path is invalid", details: nil))
            return
        }

        var format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        do {
            let file = try AVAudioFile(forReading: fileURL)
            format = file.processingFormat
            let audioFrameCount = UInt32(file.length)
            let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: audioFrameCount)

            try file.read(into: audioFileBuffer!)

            guard let floatChannelData = audioFileBuffer?.floatChannelData else {
                result(FlutterError(code: "CONVERSION_ERROR", message: "Could not convert audio data to float array", details: nil))
                return
            }

            let frameLength = Int(audioFileBuffer!.frameLength)
            let floatArray = Array(UnsafeBufferPointer(start: floatChannelData.pointee, count: frameLength))
            result(floatArray)
        } catch {
            result(FlutterError(code: "FILE_READING_ERROR", message: "Error reading audio file", details: error.localizedDescription))
        }
    }
}
