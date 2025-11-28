import 'package:field_task_app/feature/assigned_task/view/assigned_task_view.dart';
import 'package:field_task_app/feature/task/view/task_create_view.dart';
import 'package:field_task_app/feature/task/view/task_list_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's Tasks")),
      body: Column(
        children: [
          SizedBox(height: 350, child: AssignedTaskView()),
          SizedBox(height: 12),
          Divider(thickness: 1),
          SizedBox(height: 12),
          Expanded(child: TaskListView()), // wrap with Expanded
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => const TaskCreatePage()),
      ),
    );
  }
}
