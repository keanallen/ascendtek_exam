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
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Register Page",
                    style: Get.textTheme.headline6,
                  ),
                ),
              ),
              CustomTextbox(
                controller: controller.userNameTextField,
                label: 'Username',
                prefixIcon: Icons.people,
              ),
              CustomTextbox(
                controller: controller.userPassTextField,
                label: 'Password',
                prefixIcon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(
                width: context.width,
                height: 40,
                child: ElevatedButton(
                    onPressed: () => controller.login(),
                    child: const Text('LOGIN')),
              ),
              Container(
                width: context.width,
                height: 40,
                margin: const EdgeInsets.only(top: 20),
                child: TextButton(
                    onPressed: () => controller.login(),
                    child: const Text('Create an account')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
