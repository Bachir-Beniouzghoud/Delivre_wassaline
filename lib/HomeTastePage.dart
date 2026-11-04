import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';

class Hometastepage extends StatelessWidget {
  Hometastepage({super.key});
  final Authcontroller controller = Get.find<Authcontroller>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HomePage test")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            controller.regester(
              username: "username",
              email: "email@gmail.com",
              password: "password",
              phone: "065555",
              role: "dilevree",
            );
          },
          child: Text("onPressed Test"),
        ),
      ),
    );
  }
}
