import 'package:field_task_app/feature/task/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskDetailsPage extends StatelessWidget {
  final String taskId;
  const TaskDetailsPage({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskController c = Get.find<TaskController>();
    final t = c.tasks.firstWhere((e) => e.id == taskId);

    return Scaffold(
      appBar: AppBar(title: Text(t.title)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(t.description),
            const SizedBox(height: 8),
            Text('Deadline: ${t.deadline}'),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(t.lat, t.lng),
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(t.id),
                    position: LatLng(t.lat, t.lng),
                  ),
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Check-In'),
                  onPressed: () async {
                    final ok = await c.checkIn(t);
                    if (ok)
                      Get.snackbar(
                        'Checked In',
                        'Status updated to in_progress',
                      );
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  child: const Text('Complete'),
                  onPressed: () async {
                    final ok = await c.completeTask(t);
                    if (ok)
                      Get.snackbar('Completed', 'Task marked as completed');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
