import 'package:colourswift_av/bckground/scan_worker.dart';
import 'package:flutter/cupertino.dart';
import 'package:workmanager/workmanager.dart';
import '../services/defs_auto_update_service.dart';

const String defsUpdateTask = 'defs_auto_update_task';

@pragma('vm:entry-point')
void defsUpdateDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('[DefsUpdate] Worker executed');
    if (task == defsUpdateTask) {
      await DefsAutoUpdateService.maybeRun();
    }
    if (task == scheduledScanTask) {
      return await runScheduledScanTask();
    }
    return true;
  });
}

