import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:field_task_app/feature/task/controller/task_controller.dart';
import 'package:field_task_app/feature/task/view/task_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController c = Get.find<TaskController>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Create Tasks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(), // ensures title stays centered
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () {
                  c.loadLocalTasks();
                  Get.snackbar(
                    'Sync',
                    'Sync completed',
                    backgroundColor: Colors.green,
                  );
                },
              ),
            ],
          ),

          // Task List
          Expanded(
            child: Obx(() {
              final list = c.tasks;

              if (list.isEmpty) {
                return const Center(child: Text('No created tasks yet'));
              }

              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.zero,
                itemBuilder: (_, idx) {
                  final TaskModel t = list[idx];

                  return InkWell(
                    onTap: () => Get.to(() => TaskDetailsPage(taskId: t.id)),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              t.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Description
                            Text(
                              t.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Deadline
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Deadline: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  DateFormat(
                                    'MMM dd, yyyy hh:mm a',
                                  ).format(t.deadline),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Sync Status
                            Row(
                              children: [
                                const Icon(Icons.sync, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  c.getSyncStatus(t),
                                  style: TextStyle(
                                    color: c.getSyncStatusColor(t),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Status Icon
                            Row(
                              children: [
                                const Text(
                                  "Status: ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                _statusIcon(t.status),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _statusIcon(String status) {
    switch (status) {
      case 'in_progress':
        return const Icon(Icons.directions_walk, color: Colors.orange);
      case 'completed':
        return const Icon(Icons.check_circle, color: Colors.green);
      default:
        return const Icon(Icons.pending_actions_rounded, color: Colors.black);
    }
  }
}
