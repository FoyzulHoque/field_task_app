class AssignedTaskModel {
  final String id;
  final String title;
  final String description;
  final String assignedAgent;
  final double latitude;
  final double longitude;
  final String deadline;
  String status;

  AssignedTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedAgent,
    required this.latitude,
    required this.longitude,
    required this.deadline,
    required this.status,
  });

  factory AssignedTaskModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return AssignedTaskModel(
      id: id,
      title: data['title'] ?? "",
      description: data['description'] ?? "",
      assignedAgent: data['assignedAgent'] ?? "",
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      deadline: data['deadline'] ?? "",
      status: data['status'] ?? "pending",
    );
  }
}
