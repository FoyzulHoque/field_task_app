import 'package:field_task_app/feature/assigned_task/controller/assigned_task_controller.dart';

import 'package:field_task_app/feature/complete_task/view/complete_task_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignedTaskView extends StatelessWidget {
  final AssignedTaskController controller = Get.put(AssignedTaskController());

  AssignedTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final assignedTasks = controller.assignedTasks; // SHOW ALL TASKS

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "All Assigned Tasks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: assignedTasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks available",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: assignedTasks.length,
                    itemBuilder: (_, index) {
                      final task = assignedTasks[index];

                      return InkWell(
                        onTap: () => Get.to(() => CompleteTaskView(task: task)),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  task.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    const Icon(Icons.person, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Assigned To: ${task.assignedAgent}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Deadline: ${task.deadline}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    const Icon(Icons.flag, size: 18),
                                    const SizedBox(width: 6),
                                    Text("Status: "),
                                    Text(
                                      task.status,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: task.status == "completed"
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
