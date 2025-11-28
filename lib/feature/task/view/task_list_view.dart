import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:field_task_app/feature/task/controller/task_controller.dart';

import 'package:field_task_app/feature/task/view/task_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController c = Get.put(TaskController());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create tasks offline and sync when online",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          // Sync Button
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              c.loadLocalTasks();
              Get.snackbar('Sync', 'Sync completed');
            },
          ),

          // Task List
          Expanded(
            child: Obx(() {
              final list = c.tasks;

              if (list.isEmpty) {
                return const Center(child: Text('No tasks yet'));
              }

              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, idx) {
                  final TaskModel t = list[idx];

                  return ListTile(
                    title: Text(t.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${t.description}\nDue: ${t.deadline.toString()}'),
                        const SizedBox(height: 4),
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
                      ],
                    ),
                    isThreeLine: true,
                    trailing: _statusIcon(t.status),
                    onTap: () => Get.to(() => TaskDetailsPage(taskId: t.id)),
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
        return const Icon(Icons.pending, color: Colors.grey);
    }
  }
}
