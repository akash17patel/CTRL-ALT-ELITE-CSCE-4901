/*
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
      autoRunOnBoot: false,
      allowWakeLock: true,
      allowWifiLock: false,
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
  bool hasBeenInit = false;

  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
      await _audioClassification.initializeRecorder();
      log("Recorder Started");
      await _audioClassification.startRecording();
      hasBeenInit = true;
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    if (!hasBeenInit) return;
    log("Before Record");
    bool recorded = await _audioClassification.stopRecording();
    log("After Record");
    if (recorded) {
      crisis.updateValues(await _audioClassification.interference());
    }
    if (!crisis.labelValues.isEmpty) {
      log(crisis.labelValues.entries.first.value.first.toString());
    }
    await _audioClassification.startRecording();
    log("RECORD IN ONREPEAT");
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await _audioClassification.stopRecording();
    _audioClassification.dispose();
  }
}
 */