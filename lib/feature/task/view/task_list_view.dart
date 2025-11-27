import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:field_task_app/core/services/sync/sync_services.dart';
import 'package:field_task_app/feature/assigned_task/view/assigned_task_view.dart';
import 'package:field_task_app/feature/task/controller/task_controller.dart';
import 'package:field_task_app/feature/task/view/task_create_view.dart';
import 'package:field_task_app/feature/task/view/task_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskController c = Get.put(TaskController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              c.loadLocalTasks();
              Get.snackbar('Sync', 'Sync completed');
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                    subtitle: Text('${t.description}\nDue: ${t.deadline}'),
                    isThreeLine: true,
                    trailing: _statusIcon(t.status),
                    onTap: () => Get.to(() => TaskDetailsPage(taskId: t.id)),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 16),

          // Assigned Task Section (without Scaffold)
          SizedBox(height: 250, child: AssignedTaskView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => const TaskCreatePage()),
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
