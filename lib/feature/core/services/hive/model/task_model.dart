import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  double lat;

  @HiveField(4)
  double lng;

  @HiveField(5)
  DateTime deadline;

  @HiveField(6)
  String status; // pending, in_progress, completed

  @HiveField(7)
  bool isSynced;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    required this.deadline,
    this.status = 'pending',
    this.isSynced = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'lat': lat,
      'lng': lng,
      'deadline': deadline.toIso8601String(),
      'status': status,
      'isSynced': isSynced,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
      deadline: DateTime.parse(
        map['deadline'] ?? DateTime.now().toIso8601String(),
      ),
      status: map['status'] ?? 'pending',
      isSynced: map['isSynced'] ?? true,
    );
  }
}
