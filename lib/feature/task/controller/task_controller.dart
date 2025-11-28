import 'package:field_task_app/core/services/hive/hive_services.dart';
import 'package:field_task_app/core/services/hive/model/task_model.dart';

import 'package:field_task_app/core/services/sync/sync_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:field_task_app/core/services/location/location_service.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  final double checkinRadius = 100; // meters

  @override
  void onInit() {
    super.onInit();
    loadLocalTasks();
    SyncService.to.syncPendingTasks();
  }

  void loadLocalTasks() {
    tasks.value = HiveService.to.getAllTasks();
  }

  String getSyncStatus(TaskModel t) {
    if (t.isSynced) return 'Synced';
    return 'Pending';
  }

  Color getSyncStatusColor(TaskModel t) {
    return t.isSynced ? Colors.green : Colors.orange;
  }

  /// Creates a task locally and triggers a sync for pending tasks
  Future<void> createTask({
    required String title,
    required String description,
    required double lat,
    required double lng,
    required DateTime deadline,
    required String agentId,
    required String agentName,
  }) async {
    final t = await SyncService.to.createLocalTask(
      title: title,
      description: description,
      lat: lat,
      lng: lng,
      deadline: deadline,
      agentId: agentId,
      agentName: agentName,
    );

    tasks.add(t);

    // Sync all pending tasks
    await SyncService.to.syncPendingTasks();

    Get.back();
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
      Get.snackbar(
        'Cannot check in',
        reason,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    t.status = 'in_progress';
    t.isSynced = false;
    await HiveService.to.saveTask(t);
    tasks.refresh();

    // Sync all pending tasks
    await SyncService.to.syncPendingTasks();
    return true;
  }

  Future<bool> completeTask(TaskModel t) async {
    final reason = await canCheckIn(t);
    if (reason != null) {
      Get.snackbar(
        'Cannot complete',
        reason,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    t.status = 'completed';
    t.isSynced = false;
    await HiveService.to.saveTask(t);
    tasks.refresh();

    // Sync all pending tasks
    await SyncService.to.syncPendingTasks();
    return true;
  }
}
