import 'dart:isolate';
import 'dart:developer';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'audio_AI.dart';

CrisisDetection crisis = CrisisDetection();

void initForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'audio_monitoring_channel',
      channelName: 'Audio Monitoring',
      channelDescription: 'This notification appears when the foreground service is running.',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
      iconData: const NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
      ),
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 975,  // 975 milliseconds
      isOnceEvent: false,
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

void startForegroundService() {
  initForegroundTask();
  FlutterForegroundTask.startService(
    notificationTitle: 'Mindlift Crisis Detection',
    notificationText: 'Listening to audio...',
    callback: startCallback,
  );
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AudioTaskHandler());
}

class AudioTaskHandler extends TaskHandler {
  final AudioClassification _audioClassification = AudioClassification();

  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
      await _audioClassification.initializeRecorder();
      await _audioClassification.startRecording();
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    var results = await _audioClassification.stopRecording();
    crisis.updateValues(results);
    log(crisis.labelValues.entries.first.value.first.toString());
    await _audioClassification.startRecording();
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await _audioClassification.stopRecording();
    _audioClassification.dispose();
  }
}

class CrisisDetection {
  static const List<String> classificationLabels = [
    "Screaming",
    "Crying, sobbing",
    "Whimper",
    "Wail, moan",
    "Groan",
    "Sniff"
  ];

  static const double threshold = 1.0;  // Threshold to trigger a crisis event
  Map<String, List<double>> labelValues = {};

  CrisisDetection() {
    for (var label in classificationLabels) {
      labelValues[label] = [];  // Initialize with an empty list
    }
  }

  // Update values for each label and maintain only the last three entries
  void updateValues(Map<String, double> incomingValues) {
    for (var label in classificationLabels) {
      if (incomingValues.containsKey(label)) {
        var list = labelValues[label]!;
        list.add(incomingValues[label]!);  // Add new value

        // Maintain only the last three values
        if (list.length > 3) {
          list.removeAt(0);  // Remove the oldest value
        }
        labelValues[label] = list;
      }
    }
    checkCrisis();  // Check if we should trigger a crisis action
  }

  // Check if the sum of all labels' values exceeds the threshold
  void checkCrisis() {
    double sum = labelValues.values.expand((i) => i).reduce((a, b) => a + b);
    if (sum > threshold) {
      triggerCrisisAction();
    }
  }

  // Stub for triggering a crisis action
  void triggerCrisisAction() {
    // Implement action to be taken in case of crisis
    print("Crisis detected! Taking action...");
    // e.g., send notifications, alert authorities, etc.
  }
}