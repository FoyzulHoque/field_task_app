import 'package:field_task_app/core/services/hive/hive_services.dart';
import 'package:field_task_app/core/services/hive/model/assigned_task_model_hive.dart';
import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:field_task_app/core/services/sync/sync_services.dart';

import 'package:field_task_app/feature/task/controller/task_controller.dart';
import 'package:field_task_app/firebase_options.dart';
import 'package:field_task_app/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskModelAdapter());
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AssignedTaskHiveModelAdapter());
  }

  await Hive.openBox<TaskModel>('tasks');
  await Hive.openBox<AssignedTaskHiveModel>('assigned_tasks');

  final hiveService = await HiveService().init();
  Get.put(hiveService);
  // VERY IMPORTANT
  //await Get.putAsync<SyncService>(() async => SyncService());
  Get.put(SyncService());
  Get.put(TaskController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Field Task App',
        getPages: AppRoute.routes,
        initialRoute: AppRoute.splashView,
        theme: ThemeData(scaffoldBackgroundColor: Color(0xffF1F1F3)),
        builder: EasyLoading.init(),
      ),
    );
  }
}
