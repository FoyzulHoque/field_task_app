import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:field_task_app/core/services/hive/model/assigned_task_model_hive.dart';
import 'package:field_task_app/feature/assigned_task/controller/firebase_assigned_task.dart';
import 'package:field_task_app/feature/assigned_task/model/assigned_task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AssignedTaskController extends GetxController {
  final FirebaseAssignedTaskService firebaseService =
      FirebaseAssignedTaskService();

  RxList<AssignedTaskModel> assignedTasks = <AssignedTaskModel>[].obs;

  late Box<AssignedTaskHiveModel> taskBox;

  List<String> pendingCompletedTasks = [];

  @override
  void onInit() {
    super.onInit();

    taskBox = Hive.box<AssignedTaskHiveModel>('assigned_tasks');

    _loadCachedTasks(); // load offline
    _syncFirebaseTasks(); // load online if available
    _listenConnectionChanges();
  }

  /// Load cached tasks from Hive
  void _loadCachedTasks() {
    final cached = taskBox.values.map((e) {
      return AssignedTaskModel(
        id: e.id,
        title: e.title,
        description: e.description,
        assignedAgent: e.assignedAgent,
        latitude: e.latitude,
        longitude: e.longitude,
        deadline: e.deadline,
        status: e.status,
      );
    }).toList();

    assignedTasks.assignAll(cached);
  }

  /// Fetch tasks from Firebase
  void _syncFirebaseTasks() async {
    bool online = await hasInternet();
    if (!online) return;

    firebaseService.streamAllTasks().listen((firebaseList) {
      assignedTasks.assignAll(firebaseList);
      _cacheToHive(firebaseList);
    });
  }

  void _cacheToHive(List<AssignedTaskModel> list) {
    taskBox.clear();

    for (var task in list) {
      taskBox.put(
        task.id,
        AssignedTaskHiveModel(
          id: task.id,
          title: task.title,
          description: task.description,
          assignedAgent: task.assignedAgent,
          latitude: task.latitude,
          longitude: task.longitude,
          deadline: task.deadline,
          status: task.status,
        ),
      );
    }
  }

  Future<void> completeTask(AssignedTaskModel task) async {
    bool online = await hasInternet();

    var hiveTask = taskBox.get(task.id);
    if (hiveTask != null) {
      hiveTask.status = "completed";
      await hiveTask.save();
    }

    assignedTasks.firstWhere((t) => t.id == task.id).status = "completed";
    assignedTasks.refresh();

    if (online) {
      await firebaseService.updateTaskStatus(task.id, "completed");
    } else {
      pendingCompletedTasks.add(task.id);
    }
  }

  void _syncPendingCompletions() async {
    if (pendingCompletedTasks.isEmpty) return;

    for (String id in pendingCompletedTasks) {
      await firebaseService.updateTaskStatus(id, "completed");
    }
    pendingCompletedTasks.clear();
  }

  void _listenConnectionChanges() {
    Connectivity().onConnectivityChanged.listen((status) async {
      if (status != ConnectivityResult.none) {
        _syncFirebaseTasks();
        _syncPendingCompletions();
      }
    });
  }

  Future<bool> hasInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }
}
