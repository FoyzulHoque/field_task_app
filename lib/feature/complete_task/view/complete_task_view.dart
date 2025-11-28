import 'package:field_task_app/feature/assigned_task/controller/assigned_task_controller.dart';
import 'package:field_task_app/feature/assigned_task/model/assigned_task_model.dart';
import 'package:field_task_app/feature/complete_task/controller/complete_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';

// class CompleteTaskView extends StatelessWidget {
//   final AssignedTaskModel task;

//   CompleteTaskView({super.key, required this.task});

//   final CompleteTaskController controller = Get.put(CompleteTaskController());

//   @override
//   Widget build(BuildContext context) {
//     // Initialize the task safely after the first build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (controller.task.value == null) {
//         controller.initTask(task);
//       }
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text(controller.task.value?.title ?? "")),
//       ),
//       body: Obx(() {
//         if (controller.currentPosition.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return Column(
//           children: [
//             Expanded(
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: controller.currentPosition.value!,
//                   zoom: 15,
//                 ),
//                 markers: {
//                   Marker(
//                     markerId: const MarkerId("user"),
//                     position: controller.currentPosition.value!,
//                     infoWindow: const InfoWindow(title: "Your Location"),
//                     icon: BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueBlue,
//                     ),
//                   ),
//                   Marker(
//                     markerId: const MarkerId("task"),
//                     position: LatLng(
//                       controller.task.value!.latitude,
//                       controller.task.value!.longitude,
//                     ),
//                     infoWindow: const InfoWindow(title: "Task Location"),
//                     icon: BitmapDescriptor.defaultMarker,
//                   ),
//                 },
//                 polylines: controller.polylines,
//                 onMapCreated: (mapCtrl) {
//                   controller.mapController = mapCtrl;
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   Obx(
//                     () => Text(
//                       "Distance: ${controller.distance.value.toStringAsFixed(1)} meters",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: controller.distance.value <= 100
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Obx(
//                     () => ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             (controller.distance.value <= 100 &&
//                                 controller.task.value != null)
//                             ? Colors.green
//                             : Colors.grey,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 40,
//                           vertical: 15,
//                         ),
//                       ),
//                       onPressed:
//                           (controller.distance.value <= 100 &&
//                               controller.task.value != null)
//                           ? controller.completeTask
//                           : null,
//                       child: const Text(
//                         "Complete Task",
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Deadline: ${controller.task.value != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse(controller.task.value!.deadline)) : ""}",
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

class CompleteTaskView extends StatefulWidget {
  final AssignedTaskModel task;

  const CompleteTaskView({super.key, required this.task});

  @override
  State<CompleteTaskView> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<CompleteTaskView> {
  final AssignedTaskController controller = Get.find();

  GoogleMapController? mapController;
  Position? currentPosition;
  double distance = 9999;

  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    await Geolocator.requestPermission();

    currentPosition = await Geolocator.getCurrentPosition();
    _calculateDistance();
    _drawPolyline();

    setState(() {});
  }

  void _calculateDistance() {
    distance = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      widget.task.latitude,
      widget.task.longitude,
    );
  }

  /// 🔵 Draw line from current location → task location
  void _drawPolyline() {
    polylines = {
      Polyline(
        polylineId: PolylineId("route"),
        points: [
          LatLng(currentPosition!.latitude, currentPosition!.longitude),
          LatLng(widget.task.latitude, widget.task.longitude),
        ],
        width: 5,
        color: Colors.blue,
      ),
    };
  }

  Future<void> _completeTask() async {
    if (distance > 100) {
      Get.snackbar("Too Far", "You must be within 100 meters to complete.");
      return;
    }

    await controller.completeTask(widget.task);
    Get.snackbar("Success", "Task marked as completed!");
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove default back button
        backgroundColor: Colors.black,
        centerTitle: true, // Center the title
        title: Text(
          widget.task.title,
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
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        currentPosition!.latitude,
                        currentPosition!.longitude,
                      ),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId("user"),
                        position: LatLng(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                        ),
                        infoWindow: InfoWindow(title: "Your Location"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        ),
                      ),
                      Marker(
                        markerId: MarkerId("task"),
                        position: LatLng(
                          widget.task.latitude,
                          widget.task.longitude,
                        ),
                        infoWindow: InfoWindow(title: "Task Location"),
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                    },

                    polylines: polylines, // 🔹 SHOW THE POLYLINE

                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                ),

                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Distance: ${distance.toStringAsFixed(1)} meters",
                        style: TextStyle(
                          fontSize: 18,
                          color: distance <= 100 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Deadline: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(widget.task.deadline))}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // SizedBox(
                      //   width: double.infinity, // full width
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: distance <= 100
                      //           ? Colors.green
                      //           : Colors.grey,
                      //       padding: const EdgeInsets.symmetric(vertical: 15),
                      //     ),
                      //     onPressed: distance <= 100 ? _completeTask : null,
                      //     child: const Text(
                      //       "Complete Task",
                      //       style: TextStyle(fontSize: 16, color: Colors.black),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: distance <= 100 ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
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
                            backgroundColor: Colors
                                .transparent, // keep transparent to show container color
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: distance <= 100 ? _completeTask : null,
                          child: const Text(
                            "Complete Task",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
