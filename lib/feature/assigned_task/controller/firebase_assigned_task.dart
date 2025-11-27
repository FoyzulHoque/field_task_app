import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_task_app/feature/assigned_task/model/assigned_task_model.dart';

class FirebaseAssignedTaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch ALL tasks (no filter)
  Stream<List<AssignedTaskModel>> streamAllTasks() {
    return _db
        .collection('task')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AssignedTaskModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Update task status
  Future<void> updateTaskStatus(String taskId, String status) async {
    await _db.collection('task').doc(taskId).update({'status': status});
  }
}
