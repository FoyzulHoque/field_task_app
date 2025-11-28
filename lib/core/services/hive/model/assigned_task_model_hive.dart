import 'package:hive/hive.dart';
part 'assigned_task_model_hive.g.dart';

@HiveType(typeId: 1)
class AssignedTaskHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String assignedAgent;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitude;

  @HiveField(6)
  String deadline;

  @HiveField(7)
  String status; // not final, can be updated

  AssignedTaskHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedAgent,
    required this.latitude,
    required this.longitude,
    required this.deadline,
    required this.status,
  });
}
