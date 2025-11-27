import 'package:field_task_app/core/services/firebase/firebase_services.dart';
import 'package:field_task_app/core/services/hive/controller/hive_controller.dart';
import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';

class SyncService extends GetxService {
  static SyncService get to => Get.find();

  final _connectivity = Connectivity();
  final _firebase = FirebaseService();
  final _uuid = const Uuid();

  Future<SyncService> init() async {
    // HiveService is already initialized in main.dart
    // watch connectivity
    _connectivity.onConnectivityChanged.listen((c) {
      if (c != ConnectivityResult.none) {
        trySyncAll();
      }
    });
    return this;
  }

  Future<void> trySyncAll() async {
    // In a real app, use authenticated agentId; here use placeholder 'agent_1'
    const agentId = 'agent_1';
    final local = HiveService.to.getAllTasks();

    for (var t in local.where((e) => !e.isSynced)) {
      await _firebase.uploadTask(agentId, t);
      t.isSynced = true;
      await HiveService.to.saveTask(t);
    }

    // Pull remote tasks and merge (remote wins)
    final remote = await _firebase.fetchTasks(agentId);
    for (var r in remote) {
      await HiveService.to.saveTask(r);
    }
  }

  // helper to create local task with id
  TaskModel createLocalTask({
    required String title,
    required String description,
    required double lat,
    required double lng,
    required DateTime deadline,
  }) {
    final id = _uuid.v4();
    final t = TaskModel(
      id: id,
      title: title,
      description: description,
      lat: lat,
      lng: lng,
      deadline: deadline,
      isSynced: false,
    );
    HiveService.to.saveTask(t);
    return t;
  }
}
