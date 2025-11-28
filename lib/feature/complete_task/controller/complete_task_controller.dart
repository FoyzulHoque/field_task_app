import 'package:field_task_app/feature/assigned_task/controller/assigned_task_controller.dart';

import 'package:field_task_app/core/services/location/location_service.dart';
import 'package:field_task_app/feature/assigned_task/model/assigned_task_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// class CompleteTaskController extends GetxController {
//   final AssignedTaskController taskController = Get.find();

//   final task = Rx<AssignedTaskModel?>(null);
//   final currentPosition = Rx<LatLng?>(null);
//   final distance = 9999.0.obs;
//   final polylines = <Polyline>{}.obs;

//   GoogleMapController? mapController;

//   void initTask(AssignedTaskModel t) {
//     task.value = t;
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     final pos = await LocationService.getCurrentPosition();
//     currentPosition.value = LatLng(pos.latitude, pos.longitude);
//     _calculateDistance();
//     _drawPolyline();
//   }

//   void _calculateDistance() {
//     if (currentPosition.value == null || task.value == null) return;

//     distance.value = LocationService.distanceBetween(
//       currentPosition.value!.latitude,
//       currentPosition.value!.longitude,
//       task.value!.latitude,
//       task.value!.longitude,
//     );
//   }

//   void _drawPolyline() {
//     if (currentPosition.value == null || task.value == null) return;

//     polylines.value = {
//       Polyline(
//         polylineId: const PolylineId("route"),
//         points: [
//           currentPosition.value!,
//           LatLng(task.value!.latitude, task.value!.longitude),
//         ],
//         width: 5,
//         color: Colors.blue,
//       ),
//     };
//   }

//   Future<void> completeTask() async {
//     if (task.value == null) return;

//     if (distance.value > 100) {
//       Get.snackbar(
//         "Too Far",
//         "You must be within 100 meters to complete.",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.TOP,
//       );
//       return;
//     }

//     await taskController.completeTask(task.value!);

//     // show success first
//     Get.snackbar(
//       duration: Duration(seconds: 3),
//       "Success",
//       "Task marked as completed!",
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       snackPosition: SnackPosition.TOP,
//     );

//     // wait a tiny bit to ensure snackbar is visible
//     await Future.delayed(const Duration(milliseconds: 200));

//     Get.back(); // go back to previous screen
//   }
// }
