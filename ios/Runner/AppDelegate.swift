import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let audioAIChannelName = "com.example.mindlift_flutter/audio_AI"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Plugin registration
    GeneratedPluginRegistrant.register(with: self)

    // Notification center delegate setup
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    // Set up the method channel for audio conversion
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let audioConverterChannel = FlutterMethodChannel(name: audioConverterChannelName,
                                                      binaryMessenger: controller.binaryMessenger)
    audioConverterChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Handle method calls for audio conversion
      if call.method == "wavToFloatArray" {
        self?.wavToFloatArray(call: call, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Assuming you have set up a FlutterMethodChannel and this function is part of your method call handler
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