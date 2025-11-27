import 'package:field_task_app/feature/assigned_task/controller/assigned_task_controller.dart';
import 'package:field_task_app/feature/assigned_task/model/assigned_task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

// class CompleteTaskView extends StatefulWidget {
//   final AssignedTaskModel task;

//   const CompleteTaskView({required this.task});

//   @override
//   State<CompleteTaskView> createState() => _TaskDetailsScreenState();
// }

// class _TaskDetailsScreenState extends State<CompleteTaskView> {
//   final AssignedTaskController controller = Get.find();

//   GoogleMapController? mapController;
//   Position? currentPosition;
//   double distance = 9999;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     await Geolocator.requestPermission();

//     currentPosition = await Geolocator.getCurrentPosition();
//     _calculateDistance();

//     setState(() {});
//   }

//   void _calculateDistance() {
//     distance = Geolocator.distanceBetween(
//       currentPosition!.latitude,
//       currentPosition!.longitude,
//       widget.task.latitude,
//       widget.task.longitude,
//     );
//   }

//   Future<void> _completeTask() async {
//     if (distance > 100) {
//       Get.snackbar("Too Far", "You must be within 100 meters to complete.");
//       return;
//     }

//     // Auto-complete
//     await controller.completeTask(widget.task);

//     Get.snackbar("Success", "Task marked as completed!");
//     Get.back();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.task.title)),
//       body: currentPosition == null
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Expanded(
//                   child: GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(
//                         currentPosition!.latitude,
//                         currentPosition!.longitude,
//                       ),
//                       zoom: 15,
//                     ),
//                     markers: {
//                       Marker(
//                         markerId: MarkerId("user"),
//                         position: LatLng(
//                           currentPosition!.latitude,
//                           currentPosition!.longitude,
//                         ),
//                         infoWindow: InfoWindow(title: "Your Location"),
//                         icon: BitmapDescriptor.defaultMarkerWithHue(
//                           BitmapDescriptor.hueBlue,
//                         ),
//                       ),
//                       Marker(
//                         markerId: MarkerId("task"),
//                         position: LatLng(
//                           widget.task.latitude,
//                           widget.task.longitude,
//                         ),
//                         infoWindow: InfoWindow(title: "Task Location"),
//                       ),
//                     },
//                   ),
//                 ),

//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Distance: ${distance.toStringAsFixed(1)} meters",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: distance <= 100 ? Colors.green : Colors.red,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),

//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: distance <= 100
//                               ? Colors.green
//                               : Colors.grey,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 15,
//                           ),
//                         ),
//                         onPressed: distance <= 100 ? _completeTask : null,
//                         child: const Text(
//                           "Complete Task",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

class CompleteTaskView extends StatefulWidget {
  final AssignedTaskModel task;

  const CompleteTaskView({required this.task});

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
      appBar: AppBar(title: Text(widget.task.title)),
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
                      const SizedBox(height: 12),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: distance <= 100
                              ? Colors.green
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        onPressed: distance <= 100 ? _completeTask : null,
                        child: const Text(
                          "Complete Task",
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
