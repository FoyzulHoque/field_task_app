import 'package:field_task_app/core/services/hive/controller/hive_controller.dart';
import 'package:field_task_app/core/services/hive/hive_adapters.dart';
import 'package:field_task_app/core/services/hive/model/assigned_task_model_hive.dart';
import 'package:field_task_app/core/services/hive/model/task_model.dart';
import 'package:field_task_app/core/services/sync/sync_services.dart';
import 'package:field_task_app/feature/splash/view/splash_view.dart';
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

  // Configure EasyLoading settings
  configEasyLoading();

  await Firebase.initializeApp();
  await Hive.initFlutter();
  await registerHiveAdapters();
  await Hive.openBox<TaskModel>(HiveBoxes.tasks);
  await Hive.openBox<AssignedTaskHiveModel>('assigned_tasks');

  // Initialize Hive Service
  await Get.putAsync(() => HiveService().init());

  // // Kick off sync service
  await Get.putAsync(() => SyncService().init());

  // Initialize Firebase (ensure Firebase is initialized before runApp())
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

void configEasyLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.grey
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..maskColor = Colors.green
    ..userInteractions = false
    ..dismissOnTap = false;
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
