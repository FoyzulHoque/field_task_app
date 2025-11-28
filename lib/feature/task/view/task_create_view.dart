import 'package:field_task_app/core/global_widgets/global_textfield.dart';
import 'package:field_task_app/feature/task/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({super.key});

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _agentId = TextEditingController();
  final _agentName = TextEditingController();

  DateTime _deadline = DateTime.now().add(const Duration(hours: 2));
  LatLng? _picked;

  final TaskController _controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove default back button
        backgroundColor: Colors.black,
        centerTitle: true, // Center the title
        title: Text(
          'Create Task',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => Get.back(),

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Back button background
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GlobalTextField(controller: _agentId, label: 'Agent ID'),
            GlobalTextField(controller: _agentName, label: 'Agent Name'),
            GlobalTextField(controller: _title, label: 'Title'),
            GlobalTextField(
              controller: _desc,
              label: 'Description',
              maxLines: 3,
            ),

            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Deadline: ${DateFormat('MMM dd, yyyy – hh:mm a').format(_deadline)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
                          initialTime: TimeOfDay.fromDateTime(_deadline),
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
            ),
            const SizedBox(height: 5),
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
            SizedBox(height: 16),
            Container(
              width: double.infinity, // make full width
              decoration: BoxDecoration(
                color: Colors.green, // button color
                borderRadius: BorderRadius.circular(12), // rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent, // required to show container color
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (_picked == null) {
                    Get.snackbar(
                      'Select location',
                      'Tap on map to choose a location',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  if (_agentId.text.isEmpty || _agentName.text.isEmpty) {
                    Get.snackbar(
                      'Missing Agent Info',
                      'Please enter Agent ID and Name',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  await _controller.createTask(
                    title: _title.text,
                    description: _desc.text,
                    lat: _picked!.latitude,
                    lng: _picked!.longitude,
                    deadline: _deadline,
                    agentId: _agentId.text,
                    agentName: _agentName.text,
                  );
                },
                child: const Text(
                  'Save Task',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
