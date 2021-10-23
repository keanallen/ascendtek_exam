import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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

  static void spiner({String? label}) {
    Get.dialog(Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Text(
              label!,
              style: const TextStyle(height: 2, color: Colors.white),
            )
          ],
        ),
      ),
    ));
  }

  static Future selectImageSource() async {
    ImageSource? imageSource;
    await Get.bottomSheet(
        Container(
          height: 140,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  imageSource = ImageSource.gallery;
                  Get.close(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  imageSource = ImageSource.camera;
                  Get.close(1);
                },
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))));

    return imageSource!;
  }
}
