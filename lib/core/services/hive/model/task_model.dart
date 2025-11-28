import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String agentId;

  @HiveField(2)
  String agentName;

  @HiveField(3)
  String title;

  @HiveField(4)
  String description;

  @HiveField(5)
  double lat;

  @HiveField(6)
  double lng;

  @HiveField(7)
  DateTime deadline;

  @HiveField(8)
  String status; // pending, in_progress, completed

  @HiveField(9)
  bool isSynced;

  TaskModel({
    required this.id,
    required this.agentId,
    required this.agentName,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    required this.deadline,
    this.status = 'pending',
    this.isSynced = false,
  });

  Map<String, dynamic> toFirebaseMap() {
    return {
      'id': id,
      'agentId': agentId,
      'agentName': agentName,
      'title': title,
      'description': description,
      'lat': lat,
      'lng': lng,
      'deadline': deadline.toIso8601String(),
      'status': status,
      'isSynced': true,
    };
  }
}
