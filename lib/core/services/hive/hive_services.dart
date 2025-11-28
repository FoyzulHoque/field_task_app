import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HiveService extends GetxService {
  static HiveService get to => Get.find();

  late Box<TaskModel> _taskBox;

  // Return this instance after initialization
  Future<HiveService> init() async {
    _taskBox = await Hive.openBox<TaskModel>('tasks');
    return this;
  }

  List<TaskModel> getAllTasks() => _taskBox.values.toList();

  Future<TaskModel> saveTask(TaskModel t) async {
    await _taskBox.put(t.id, t);
    return t;
  }

  List<TaskModel> getPendingSync() {
    return _taskBox.values
        .where((e) => !e.isSynced && e.status == 'completed')
        .toList();
  }
}
