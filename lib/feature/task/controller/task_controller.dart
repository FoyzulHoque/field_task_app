import 'package:field_task_app/core/services/hive/controller/hive_controller.dart';
import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:field_task_app/core/services/location/location_service.dart';
import 'package:field_task_app/core/services/sync/sync_services.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  final double checkinRadius = 100; // meters

  @override
  void onInit() {
    super.onInit();
    loadLocalTasks();
  }

  void loadLocalTasks() {
    tasks.value = HiveService.to.getAllTasks();
  }

  Future<void> createTask(
    String title,
    String description,
    double lat,
    double lng,
    DateTime deadline,
  ) async {
    final t = SyncService.to.createLocalTask(
      title: title,
      description: description,
      lat: lat,
      lng: lng,
      deadline: deadline,
    );
    tasks.add(t);
  }

  Future<String?> canCheckIn(TaskModel t) async {
    try {
      final pos = await LocationService.getCurrentPosition();
      final distance = LocationService.distanceBetween(
        pos.latitude,
        pos.longitude,
        t.lat,
        t.lng,
      );
      if (distance <= checkinRadius) return null;
      return 'You are ${distance.toStringAsFixed(1)} m away. Move closer to check-in.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> checkIn(TaskModel t) async {
    final reason = await canCheckIn(t);
    if (reason != null) {
      Get.snackbar('Cannot check in', reason);
      return false;
    }

    t.status = 'in_progress';
    t.isSynced = false;
    await HiveService.to.saveTask(t);
    tasks.refresh();
    return true;
  }

  Future<bool> completeTask(TaskModel t) async {
    final reason = await canCheckIn(t);
    if (reason != null) {
      Get.snackbar('Cannot complete', reason);
      return false;
    }
    t.status = 'completed';
    t.isSynced = false;
    await HiveService.to.saveTask(t);
    tasks.refresh();
    return true;
  }
}
