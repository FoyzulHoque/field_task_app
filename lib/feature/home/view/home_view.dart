import 'package:field_task_app/feature/assigned_task/view/assigned_task_view.dart';
import 'package:field_task_app/feature/task/view/task_create_view.dart';
import 'package:field_task_app/feature/task/view/task_list_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Taskboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(child: AssignedTaskView()),
          SizedBox(height: 12),
          Divider(thickness: 2, color: Colors.black),
          SizedBox(height: 12),
          Expanded(child: TaskListView()), // wrap with Expanded
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
        onPressed: () => Get.to(() => const TaskCreatePage()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // ✅ centers it at the bottom
    );
  }
}
