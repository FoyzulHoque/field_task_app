import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_task_app/core/services/hive/hive_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../hive/model/task_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService extends GetxService {
  static SyncService get to => Get.find();

  late FirebaseFirestore _fire;

  bool _listening = false;

  @override
  void onInit() {
    super.onInit();

    // ✅ Firestore is now safe to initialize
    _fire = FirebaseFirestore.instance;

    _setupConnectivityListener();
  }

  Future<TaskModel> createLocalTask({
    required String title,
    required String description,
    required double lat,
    required double lng,
    required DateTime deadline,
    required String agentId,
    required String agentName,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final task = TaskModel(
      id: id,
      agentId: agentId,
      agentName: agentName,
      title: title,
      description: description,
      lat: lat,
      lng: lng,
      deadline: deadline,
      status: "pending",
      isSynced: false,
    );

    await HiveService.to.saveTask(task);
    await syncPendingTasks();

    return task;
  }

  Future<void> syncPendingTasks() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      if (kDebugMode) print("No internet. Skipping sync.");
      return;
    }

    final pending = HiveService.to.getPendingSync();
    for (var t in pending) {
      await _syncTaskToFirebase(t);
    }
  }

  Future<void> _syncTaskToFirebase(TaskModel task) async {
    try {
      await _fire.collection('agents').doc(task.id).set({
        'agentId': task.agentId,
        'agentName': task.agentName,
        'title': task.title,
        'description': task.description,
        'lat': task.lat,
        'lng': task.lng,
        'deadline': task.deadline.toIso8601String(),
        'status': task.status,
      });

      task.isSynced = true;
      await HiveService.to.saveTask(task);
      if (kDebugMode) print("Task ${task.id} synced successfully.");
    } catch (e) {
      if (kDebugMode) print("Error syncing task ${task.id}: $e");
    }
  }

  void _setupConnectivityListener() {
    if (_listening) return;
    _listening = true;

    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        if (kDebugMode) print("Internet back. Syncing pending tasks...");
        syncPendingTasks();
      }
    });
  }
}
