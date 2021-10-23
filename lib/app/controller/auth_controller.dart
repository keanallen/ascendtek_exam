import 'package:ascendtek_exam/app/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  TextEditingController userNameTextField = TextEditingController();
  TextEditingController userPassTextField = TextEditingController();

  void login() {
    if (userNameTextField.text.trim().isEmpty ||
        userPassTextField.text.trim().isEmpty) {
      CustomDialog.alert(
          title: 'Warning', content: 'Username/Password is required');
    }
  }
}
