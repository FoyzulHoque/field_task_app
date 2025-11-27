import 'package:field_task_app/feature/splash/controller/spalsh_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SpalshController());
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/splashlogo.png"),
              SizedBox(height: 100),
              SpinKitCircle(color: Colors.red, size: 80.0),
              //SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
