import 'package:workmanager/workmanager.dart';
import 'widget_service.dart';

const String backgroundTaskName = 'cryptoWidgetUpdate';
const String backgroundTaskTag = 'crypto_update';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await WidgetService.initialize();
      await WidgetService.fetchAndUpdateWidget();
      return true;
    } catch (e) {
      print('Background Task Error: $e');
      return false;
    }
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static Future<void> registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      backgroundTaskName,
      backgroundTaskTag,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
  }

  static Future<void> runImmediateTask() async {
    await Workmanager().registerOneOffTask(
      '${backgroundTaskName}_immediate',
      backgroundTaskTag,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
