import 'package:workmanager/workmanager.dart';
import '../bckground/defs_update_worker.dart';

class DefsUpdateScheduler {
  static Future<void> init() async {
    await Workmanager().initialize(
      defsUpdateDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> enable() async {
    await Workmanager().registerPeriodicTask(
      defsUpdateTask,
      defsUpdateTask,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  static Future<void> disable() async {
    await Workmanager().cancelByUniqueName(defsUpdateTask);
  }
}
