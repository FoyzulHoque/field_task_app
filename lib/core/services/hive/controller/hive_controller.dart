import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class HiveService extends GetxService {
  late Box<TaskModel> _tasksBox;

  static HiveService get to => Get.find();

  Future<HiveService> init() async {
    _tasksBox = Hive.box<TaskModel>('tasks_box');
    return this;
  }

  List<TaskModel> getAllTasks() {
    return _tasksBox.values.toList();
  }

  Future<void> saveTask(TaskModel t) async {
    await _tasksBox.put(t.id, t);
  }

  TaskModel? getTask(String id) {
    return _tasksBox.get(id);
  }

  Future<void> deleteTask(String id) async {
    await _tasksBox.delete(id);
  }
}
