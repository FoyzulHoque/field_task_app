import 'package:field_task_app/feature/task/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({Key? key}) : super(key: key);

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(hours: 2));
  LatLng? _picked;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TaskController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _desc,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Deadline: ${_deadline.toLocal()}'.split('.').first),
                const Spacer(),
                TextButton(
                  child: const Text('Pick'),
                  onPressed: () async {
                    final dt = await showDatePicker(
                      context: context,
                      initialDate: _deadline,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (dt != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          _deadline = DateTime(
                            dt.year,
                            dt.month,
                            dt.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(23.7808875, 90.2792371),
                  zoom: 12,
                ),
                onTap: (pos) => setState(() => _picked = pos),
                markers: _picked == null
                    ? {}
                    : {
                        Marker(
                          markerId: const MarkerId('picked'),
                          position: _picked!,
                        ),
                      },
              ),
            ),
            ElevatedButton(
              child: const Text('Save Task'),
              onPressed: () async {
                if (_picked == null) {
                  Get.snackbar(
                    'Select location',
                    'Tap on map to choose a location',
                  );
                  return;
                }
                await c.createTask(
                  _title.text,
                  _desc.text,
                  _picked!.latitude,
                  _picked!.longitude,
                  _deadline,
                );
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
