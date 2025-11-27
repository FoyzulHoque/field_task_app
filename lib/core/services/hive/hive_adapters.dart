import 'package:field_task_app/core/services/hive/manual_task_adapter.dart';
import 'package:hive/hive.dart';

Future<void> registerHiveAdapters() async {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskModelAdapter());
  }
}

class HiveBoxes {
  static const String tasks = 'tasks_box';
}
