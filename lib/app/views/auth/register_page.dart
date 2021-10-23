import 'package:ascendtek_exam/app/controller/auth_controller.dart';
import 'package:ascendtek_exam/app/widgets/custom_textbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put<AuthController>(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextbox(
                controller: controller.nameTextField,
                label: 'Name',
                prefixIcon: Icons.people,
              ),
              CustomTextbox(
                controller: controller.emailTextField,
                label: 'Email',
                prefixIcon: Icons.mail,
              ),
              CustomTextbox(
                controller: controller.passwordTextField,
                label: 'Password',
                prefixIcon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(
                width: context.width,
                height: 40,
                child: Obx(() => ElevatedButton(
                    onPressed: controller.requesting.value
                        ? null
                        : () => controller.register(),
                    child: Text(controller.requesting.value
                        ? 'REGISTERING...'
                        : 'REGISTER'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
