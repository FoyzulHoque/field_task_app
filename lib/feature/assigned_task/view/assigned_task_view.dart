import 'package:field_task_app/feature/assigned_task/controller/assigned_task_controller.dart';

import 'package:field_task_app/feature/complete_task/view/complete_task_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                "All Assigned Tasks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: assignedTasks.isEmpty
                ? const Center(
                    child: Text(
                      "No assigned available",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: assignedTasks.length,
                    itemBuilder: (_, index) {
                      final task = assignedTasks[index];

                      return InkWell(
                        onTap: () => Get.to(() => CompleteTaskView(task: task)),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Rounded corners
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 4, // subtle shadow
                          shadowColor: Colors.grey.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  task.description,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.person, size: 18),
                                    const SizedBox(width: 6),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Assigned To: ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .black, // label in black
                                            ),
                                          ),
                                          TextSpan(
                                            text: task.assignedAgent,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .green, // agent name in green
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Deadline: ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .black, // label in black
                                            ),
                                          ),
                                          TextSpan(
                                            text: DateFormat('MMM dd, yyyy')
                                                .format(
                                                  DateTime.parse(task.deadline),
                                                ),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.red, // date in red
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.flag,
                                      size: 18,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text("Status: "),
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
