import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static void alert({required String title, required String content}) {
    Get.defaultDialog(
      title: title,
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Get.close(1),
          child: const Text('Okay'),
        )
      ],
    );
  }
}
