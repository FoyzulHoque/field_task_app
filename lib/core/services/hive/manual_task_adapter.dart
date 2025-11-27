import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:hive/hive.dart';

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final lat = reader.readDouble();
    final lng = reader.readDouble();
    final deadline = DateTime.parse(reader.readString());
    final status = reader.readString();
    final isSynced = reader.readBool();
    return TaskModel(
      id: id,
      title: title,
      description: description,
      lat: lat,
      lng: lng,
      deadline: deadline,
      status: status,
      isSynced: isSynced,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeDouble(obj.lat);
    writer.writeDouble(obj.lng);
    writer.writeString(obj.deadline.toIso8601String());
    writer.writeString(obj.status);
    writer.writeBool(obj.isSynced);
  }
}
