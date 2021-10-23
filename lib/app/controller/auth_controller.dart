import 'package:ascendtek_exam/app/views/home/home_page.dart';
import 'package:ascendtek_exam/app/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class AuthController extends GetxController {
  // Login
  TextEditingController userNameTextField = TextEditingController();
  TextEditingController userPassTextField = TextEditingController();
  // Register
  TextEditingController nameTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  var requesting = false.obs;

  void login() async {
    if (userNameTextField.text.trim().isEmpty ||
        userPassTextField.text.trim().isEmpty) {
      CustomDialog.alert(
          title: 'Warning', content: 'Username/Password is required');
    }
    requesting.value = true;

    var user = ParseUser(userNameTextField.text.trim(),
        userPassTextField.text.trim(), userNameTextField.text.trim());

    var response = await user.login();
    requesting.value = false;
    if (response.success) {
      Get.offAll(() => const HomePage());
    } else {
      CustomDialog.alert(
          title: 'Failed',
          content: response.error!.message.replaceAll('username', 'email'));
    }
  }

  void register() async {
    if (nameTextField.text.trim().isEmpty) {
      CustomDialog.alert(title: 'Warning', content: 'Your Name is Required.');
      return;
    }
    if (emailTextField.text.trim().isEmpty) {
      CustomDialog.alert(
          title: 'Warning', content: 'Email Address is required');
      return;
    }
    if (passwordTextField.text.trim().isEmpty) {
      CustomDialog.alert(title: 'Warning', content: 'Password is required');
      return;
    }

    requesting.value = true;
    var user = ParseUser(emailTextField.text.trim(),
        passwordTextField.text.trim(), emailTextField.text.trim())
      ..set('name', nameTextField.text.trim());

    var response = await user.create();

    if (response.success) {
      //user.set('name', nameTextField.text.trim());
      // user.save();
      emailTextField.clear();
      nameTextField.clear();
      passwordTextField.clear();
      CustomDialog.alert(
          title: 'Success',
          content:
              'You have successfully created your account. You can now login!');
    } else {
      CustomDialog.alert(
          title: 'Failed',
          content: response.error!.message.replaceAll('username', 'email'));
    }
    requesting.value = false;
  }
}
