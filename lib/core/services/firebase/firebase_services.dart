import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_task_app/core/services/hive/model/task_model.dart';

class FirebaseService {
  final _fire = FirebaseFirestore.instance;

  // Modify path per your auth structure
  CollectionReference taskCollection(String agentId) =>
      _fire.collection('agents').doc(agentId).collection('tasks');

  Future<void> uploadTask(String agentId, TaskModel t) async {
    await taskCollection(agentId).doc(t.id).set(t.toMap());
  }

  Future<List<TaskModel>> fetchTasks(String agentId) async {
    final snap = await taskCollection(agentId).get();
    return snap.docs
        .map((d) => TaskModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }
}
